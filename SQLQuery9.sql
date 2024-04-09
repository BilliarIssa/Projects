CREATE FUNCTION CompanyCount1(
    @Status NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM rams r
    INNER JOIN rams1 r1 ON r.City_id = r1.Track_ID
    WHERE r1.Status = @Status;

    RETURN @Count;
END
GO
