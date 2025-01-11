CREATE FUNCTION IsWebinarAvailable(@StudentID INT, @WebinarID INT)
RETURNS BIT
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0;

    -- Check if Webinar exists
    IF NOT EXISTS(SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        RETURN 0;

    -- Check if Webinar is available for the Student
    IF NOT EXISTS(
        SELECT 1
        FROM WebinarAvailabilities wa
        WHERE wa.StudentID = @StudentID
          AND wa.WebinarID = @WebinarID
          AND wa.AvailableUntil >= GETUTCDATE()
    )
        RETURN 0;

    RETURN 1;
END;
