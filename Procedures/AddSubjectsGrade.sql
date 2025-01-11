CREATE PROCEDURE AddSubjectsGrade(
    @StudentID INT,
    @GradeValue DECIMAL(2,1),
    @SubjectID INT
)
AS
    BEGIN
        -- Check if subject exists
        IF NOT EXISTS(SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
            BEGIN
                RAISERROR ('Subject of ID %d does not exist', 16, 1, @SubjectID);
            END
        -- Check if grade exists
        IF NOT EXISTS(SELECT 1 FROM Grades WHERE GradeValue = @GradeValue)
            BEGIN
                DECLARE @GradeValueString VARCHAR(10) = @GradeValue;
                RAISERROR ('Grade of value %s does not exist', 16, 1, @GradeValueString);
            END
        DECLARE @GradeID INT;
        SELECT @GradeID = GradeID FROM Grades WHERE GradeValue = @GradeValue;
        INSERT INTO SubjectsGrades (GradeID, StudentID, SubjectID) VALUES (@GradeID,@StudentID,@SubjectID);
    END
GO