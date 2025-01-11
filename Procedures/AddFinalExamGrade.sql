CREATE PROCEDURE AddFinalExamGrade(
    @StudentID INT,
    @SyllabusID INT,
    @GradeValue DECIMAL(2,1)
)
AS
    BEGIN
        -- Check if the syllabus exists
        IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
        -- Check if grade exists
        IF NOT EXISTS(SELECT 1 FROM Grades WHERE GradeValue = @GradeValue)
            BEGIN
                DECLARE @GradeValueString VARCHAR(MAX) = @GradeValue;
                RAISERROR ('Grade of value %s does not exist', 16, 1, @GradeValueString);
            END
        DECLARE @GradeID INT;
        SELECT @GradeID = GradeID FROM Grades WHERE GradeValue = @GradeValue;
        INSERT INTO FinalExamGrades (GradeID, StudentID, SyllabusID) VALUES (@GradeID,@StudentID,@SyllabusID);
    END
GO;