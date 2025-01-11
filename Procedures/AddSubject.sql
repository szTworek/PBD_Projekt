CREATE PROCEDURE AddSubject
(
    @SubjectName VARCHAR(64),
    @SyllabusID INT,
    @Description VARCHAR(MAX) = NULL
)
AS
BEGIN
    BEGIN TRANSACTION;
    IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
    INSERT INTO Subjects (SubjectName, SyllabusID, Description) VALUES (@SubjectName,@SyllabusID,@Description);
    COMMIT TRANSACTION;
END;
GO;