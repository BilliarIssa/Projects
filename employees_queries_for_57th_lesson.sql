/*1. Найдите количество сотрудников мужского пола (M) и женского пола (F) и выведите записи 
в порядке убывания по количеству сотрудников.*/

SELECT 
    gender, COUNT(emp_no) AS count_by_gender
FROM
    employees
WHERE
    gender IN ('M' , 'F')
GROUP BY gender
ORDER BY count_by_gender DESC;

# another way to solve эту задачку через вложенный запрос:
SELECT 
    gender, count_by_gender
FROM
    (SELECT 
        gender, COUNT(emp_no) AS count_by_gender
    FROM
        employees
    WHERE
        gender IN ('M' , 'F')
    GROUP BY gender) AS gender_counts
ORDER BY count_by_gender DESC;

/*2. Найдите среднюю зарплату в разрезе должностей сотрудников (title), округлите эти средние 
зарплаты до 2 знаков после запятой и выведите записи в порядке убывания.*/

SELECT 
    b.title, ROUND(AVG(a.salary), 2) AS avg_salary
FROM
    salaries AS a
        JOIN
    titles AS b ON a.emp_no = b.emp_no
GROUP BY b.title
ORDER BY avg_salary DESC;

/*3. Найдите всех сотрудников, которые работали как минимум в 2 департаментах. Вывести их имя, 
фамилию и количество департаментов, в которых они работали. Показать записи в порядке возрастания.*/
SELECT 
    e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS FIO,
    COUNT(d.dept_no) AS count_dep
FROM
    employees AS e
    JOIN
    dept_emp AS d ON e.emp_no = d.emp_no 
GROUP BY e.emp_no
HAVING count_dep > 1
ORDER BY e.emp_no;

/*что если в 3й задачке после количества департаментов мы хотим увидеть имена этих 2 департамента как в примере с self join, 
тогда придется поджойнить по emp_no таблицу dept_emp самим с собой AND добавить условие a.dept_no > b.emp_no и вывести в select 
эти два значения дополнительно, но так как у нас GROUP BY по e.emp_no придется еще поджойнить с b.emp_no далее так получится
ли увидеть названия каждого департамента в отдельных колонках?*/
/*Чтобы в третьем задании показать названия департаментов, в которых работал сотрудник, мы джоиним с таблицей departments:*/
SELECT
e.emp_no,
CONCAT(e.first_name, ' ', e.last_name) AS FIO,
COUNT(d.dept_no) AS count_dep,
GROUP_CONCAT(de.dept_name SEPARATOR ', ') AS dept_names
FROM
employees AS e
JOIN
dept_emp AS d ON e.emp_no = d.emp_no
JOIN
departments AS de ON d.dept_no = de.dept_no
GROUP BY e.emp_no
HAVING count_dep > 1
ORDER BY e.emp_no;
/*Если же нам нужно вывести название каждого департамента в отдельной колонке, придется прибегнуть 
к более сложному запросу с подзапросом и оконной функцией:*/

SELECT
e.emp_no,
CONCAT(e.first_name, ' ', e.last_name) AS FIO,
MIN(CASE WHEN d.num = 1 THEN de.dept_name END) AS first_dept_name,
MIN(CASE WHEN d.num = 2 THEN de.dept_name END) AS second_dept_name
FROM
employees AS e
JOIN
(SELECT emp_no, dept_no, ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY from_date) AS num
FROM dept_emp) AS d ON e.emp_no = d.emp_no
JOIN
departments AS de ON d.dept_no = de.dept_no
GROUP BY e.emp_no
HAVING COUNT(d.dept_no) > 1
ORDER BY e.emp_no;

#4. Вывести имя, фамилию и зарплату самого высокооплачиваемого сотрудника.
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS FIO,
    s.salary AS max_salary
FROM
    employees AS e
        JOIN
    salaries AS s ON e.emp_no = s.emp_no
WHERE
    s.salary = (SELECT 
            MAX(salary)
        FROM
            salaries);

#5. Вывести месяцы (от 1 до 12), и количество нанятых сотрудников в эти месяцы.
SELECT 
    MONTH(hire_date) AS hire_month, COUNT(emp_no) AS count_emp
FROM
    employees
GROUP BY hire_month
ORDER BY hire_month;

#6. Создайте VIEW на базе 1-го запроса.
/*1. Найдите количество сотрудников мужского пола (M) и женского пола (F) и выведите записи 
в порядке убывания по количеству сотрудников.*/

CREATE VIEW emp_temp AS
SELECT 
    gender, COUNT(emp_no) AS count_by_gender
FROM
    employees
WHERE
    gender IN ('M' , 'F')
GROUP BY gender
ORDER BY count_by_gender DESC;

SELECT * FROM emp_temp;