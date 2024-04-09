
#1. Создать процедуру, в которой мы получаем на вход два параметра p_salary, p_dept и на выходе получим:

-- Список сотрудников (emp_no, first_name, gender), у которых средняя зарплата больше p_salary и которые когда-то работали в департаменте p_dept.

DELIMITER $$

DROP PROCEDURE IF EXISTS getSalaryfromEmp $$
CREATE PROCEDURE getSalaryfromEmp(IN p_salary INT, IN p_dept VARCHAR(20))
BEGIN
SELECT 
    e.emp_no, e.first_name, e.gender
FROM
    employees AS e
        JOIN
    salaries AS s ON e.emp_no = s.emp_no
        JOIN
    dept_emp AS d ON d.emp_no = e.emp_no
WHERE
    d.dept_no = p_dept
GROUP BY e.emp_no
HAVING AVG(s.salary) > p_salary
ORDER BY AVG(s.salary);

END $$

DELIMITER ;
CALL getSalaryfromEmp(80197, 'd005');

#2. Создать функцию, которая получает на вход f_name и выдает максимальную зарплату среди сотрудников с именем f_name.
DELIMITER $$

CREATE FUNCTION max_salary_by_f_name (f_name VARCHAR(50)) RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE max_salary INT;
SELECT 
    MAX(s.salary)
INTO max_salary FROM
    salaries s
        INNER JOIN
    employees e ON s.emp_no = e.emp_no
WHERE
    e.first_name = f_name;
    RETURN max_salary;
    
END$$

DELIMITER ;
SELECT max_salary_by_f_name('Georgi');

#Следующие запросы относятся к базе данных World (скачайте ее ниже, и запустите все запросы, как мы делали с employees):

USE world;
SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM countrylanguage;

#1. Посчитайте количество городов в каждой стране, где IndepYear = 1991 (Independence Year).
SELECT distinct(a.Name), COUNT(b.Name) as city_count FROM country a
INNER join city b
ON a.code = b.CountryCode
GROUP BY a.Name
ORDER BY city_count DESC; #дополнительно сортируем по количеству городов по убыванию 

#2. Узнайте, какая численность населения и средняя продолжительность жизни людей в Аргентине (ARG).
SELECT population, ROUND(AVG(LifeExpectancy),2) as avg_life FROM country #дополнительно округляем число для визуальности
WHERE code = 'ARG';

#3. В какой стране самая высокая продолжительность жизни?

SELECT name, LifeExpectancy 
FROM country 
WHERE LifeExpectancy = (SELECT MAX(LifeExpectancy) FROM country);

#4. Перечислите все языки, на которых говорят в регионе «Southeast Asia».
SELECT DISTINCT(a.Language) 
FROM countrylanguage as a
join country as b
ON a.CountryCode = b.Code
WHERE b.Region = 'Southeast Asia'
ORDER BY a.Language; #дополнительно сортируем по алф порядку

#5. Посчитайте сумму SurfaceArea для каждого континента.
SELECT Continent, ROUND(SUM(SurfaceArea),0) as SUM_area #округляем просто без нулей чтобы было как #,00
FROM country
GROUP BY Continent
ORDER BY SUM_area DESC; #дополнительно сортируем по убыванию суммы
