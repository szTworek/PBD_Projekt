CREATE PROCEDURE AddCourse
    (
        @Topic VARCHAR(64),
        @ClassLecturerID INT,
        @CoursePrice MONEY,
        @Language VARCHAR(32),
        @PriceChange REAL,
        @TranslatorID INT = NULL,
        @Description VARCHAR(MAX) = NULL
    )
AS
    BEGIN
        -- Check if translator exists
        IF @TranslatorID IS NOT NULL
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
            BEGIN
                RAISERROR ('Translator of ID %d does not exist', 16,1,@TranslatorID);
            END
        END
        -- Check if employee exists
        IF NOT EXISTS(SELECT 1 FROM Employees WHERE EmployeeID = @ClassLecturerID)
            BEGIN
                RAISERROR  ('Employee of ID %d does not exist', 16,1,@ClassLecturerID);
            END
        -- Check if the language exists
        IF NOT EXISTS(SELECT 1 FROM Languages WHERE LanguageName = @Language)
            BEGIN
                RAISERROR  ('Language %s does not exist', 16,1,@Language);
            END
        DECLARE @LanguageID INT;
        SELECT @LanguageID = LanguageID FROM Languages WHERE LanguageName = @Language;
        DECLARE @CourseTable TABLE(CourseID INT);
        INSERT INTO Courses (Topic,Description,CoursePrice,LanguageID,PriceChange,TranslatorID)
        OUTPUT INSERTED.CourseID INTO @CourseTable
        VALUES (@Topic,@Description,@coursePrice, @LanguageID, @PriceChange,@TranslatorID)
        DECLARE @CourseID INT;
        SELECT @CourseID = CourseID FROM @CourseTable;
        INSERT INTO CourseLecturers (LecturerID, CourseID) VALUES (@ClassLecturerID, @CourseID);
    END
GO;
