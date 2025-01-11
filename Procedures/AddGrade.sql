CREATE PROCEDURE AddGrade(
    @GradeID INT,
    @GradeValue DECIMAL(2,1),
    @GradeName VARCHAR(64)
)
AS
    BEGIN
        INSERT INTO Grades (GradeID, GradeValue, GradeName) VALUES (@GradeID,@GradeValue,@GradeName);
    END
GO