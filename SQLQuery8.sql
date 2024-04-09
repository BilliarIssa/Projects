SELECT DISTINCT 
    r.name_company, 
    r.passport_id, 
    r.quantity, 
    r1.Status
INTO SORTED
FROM 
    rams r
JOIN 
    rams1 r1 ON r1.Track_ID = r.City_id;