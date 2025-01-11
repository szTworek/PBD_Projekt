CREATE PROCEDURE AddInternship(
    @StartDate DATE,
    @SyllabusID INT,
    @InternshipDays INT = 14
)
AS
BEGIN
    BEGIN TRANSACTION;
    -- Check if syllabus exists
    IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
    INSERT INTO Internships (StartDate, InternshipDays, SyllabusID) VALUES (@StartDate, @InternshipDays, @SyllabusID)
    COMMIT TRANSACTION;
END
GO;
