CREATE PROCEDURE GetTracksByStatus
    @Status NVARCHAR(100)
AS
BEGIN
    SELECT Track_ID, CITY, Status
    FROM rams
    WHERE Status = @Status;
END;
GO
