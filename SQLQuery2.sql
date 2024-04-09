SELECT DISTINCT r.name_company, r.passport_id, r.quantity, r1.Status
FROM rams r
JOIN rams1 r1 ON r1.Track_ID = r.City_id

WHERE r.quantity > (SELECT AVG(quantity) from rams); 