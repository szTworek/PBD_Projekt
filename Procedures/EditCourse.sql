CREATE PROCEDURE EditCourse
    @CourseID INT,
    @Topic VARCHAR(64) = NULL,
    @Description VARCHAR(MAX) = NULL,
    @CoursePrice MONEY = NULL,
    @LanguageID INT = NULL,
    @PriceChange REAL = NULL,
    @TranslatorID INT = NULL
AS
BEGIN
    IF @CoursePrice <= 0
        THROW 50001, 'CoursePrice must be greater than 0.', 1;

    IF @PriceChange IS NOT NULL AND @PriceChange <= 0
        THROW 50002, 'PriceChange must be greater than 0.', 1;

    IF @CourseID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        THROW 50003, 'CourseID does not exist.', 1;

    IF @LanguageID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        THROW 50004, 'LanguageID does not exist.', 1;

    IF @TranslatorID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
        THROW 50005, 'TranslatorID does not exist.', 1;

    BEGIN TRY
        UPDATE Courses
        SET
            Topic = ISNULL(@Topic,Topic),
            Description = ISNULL(@Description,Description),
            CoursePrice = ISNULL(@CoursePrice,CoursePrice),
            LanguageID = ISNULL(@LanguageID,LanguageID),
            PriceChange = ISNULL(@PriceChange,PriceChange),
            TranslatorID = ISNULL(@TranslatorID,TranslatorID)
        WHERE
            CourseID = @CourseID;
        PRINT 'Course information updated.';
    END TRY

    BEGIN CATCH
        PRINT 'An error occurred:';
        PRINT ERROR_MESSAGE();
    END CATCH

END;
go

grant execute on dbo.EditCourse to Director
go

