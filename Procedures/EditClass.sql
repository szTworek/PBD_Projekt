CREATE PROCEDURE EditClass
    @ClassID INT,
    @SubjectID INT = NULL,
    @Topic VARCHAR(64) = NULL,
    @Description VARCHAR(MAX) = NULL,
    @ClassPrice    MONEY = NULL,
    @ClassDateTime DATETIME = NULL,
    @Duration TIME(0) = NULL,
    @LanguageID INT = NULL,
    @TranslatorID INT = NULL,
    @PriceChange REAL = NULL,
    @ClassTypeID INT = NULL,
    @LimitedPlaces INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Classes WHERE ClassID = @ClassID)
        THROW 50001, 'ClassID does not exist.', 1;

    IF @SubjectID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
        THROW 50002, 'SubjectID does not exist.', 1;

    IF @LanguageID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        THROW 50003, 'LanguageID does not exist.', 1;

    IF @ClassTypeID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ClassTypes WHERE ClassTypeID = @ClassTypeID)
        THROW 50004, 'ClassTypeID does not exist.', 1;

    IF @TranslatorID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
        THROW 50005, 'TranslatorID does not exist.', 1;

    IF @ClassPrice <= 0
        THROW 50006, 'ClassPrice cannot be negative.', 1;

    IF @PriceChange < 0
        THROW 50007, 'PriceChange value must be positive.', 1;

    IF @LimitedPlaces < 0
        THROW 50008, 'LimitedPlaces value must be positive.', 1;

    BEGIN TRY

        UPDATE Classes
        SET
            SubjectID     = ISNULL(@SubjectID, SubjectID),
            Topic         = ISNULL(@Topic, Topic),
            Description   = ISNULL(@Description, Description),
            ClassPrice    = ISNULL(@ClassPrice, ClassPrice),
            ClassDateTime = ISNULL(@ClassDateTime, ClassDateTime),
            Duration      = ISNULL(@Duration, Duration),
            LanguageID    = ISNULL(@LanguageID, LanguageID),
            TranslatorID  = ISNULL(@TranslatorID, TranslatorID),
            PriceChange   = ISNULL(@PriceChange, PriceChange),
            ClassTypeID   = ISNULL(@ClassTypeID, ClassTypeID),
            LimitedPlaces = ISNULL(@LimitedPlaces, LimitedPlaces)
        WHERE ClassID = @ClassID;
        PRINT 'Class information updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
go

grant execute on dbo.EditClass to ClassCoordinator
go

grant execute on dbo.EditClass to Director
go

