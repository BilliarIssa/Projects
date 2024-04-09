UPDATE rams
SET phone_number = '7 (' + SUBSTRING(CAST(phone_number AS VARCHAR), 2, 3) + ') ' +
                   SUBSTRING(CAST(phone_number AS VARCHAR), 5, 3) + ' ' +
                   SUBSTRING(CAST(phone_number AS VARCHAR), 8, 2) + ' ' +
                   SUBSTRING(CAST(phone_number AS VARCHAR), 10, 2);



				   