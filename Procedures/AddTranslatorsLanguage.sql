CREATE PROCEDURE AddTranslatorsLanguage
    @TranslatorID INT,
    @LanguageName NVARCHAR(127)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @LanguageID INT;

    SELECT @LanguageID = LanguageID
    FROM Languages
    WHERE LanguageName = @LanguageName;

    -- Add language
    IF @LanguageID IS NULL
    BEGIN
        INSERT INTO Languages (LanguageName)
        VALUES (@LanguageName);
        SELECT @LanguageID = LanguageID FROM Languages WHERE LanguageName = @LanguageName;
    END

    INSERT INTO TranslatorsLanguages (TranslatorID, LanguageID)
    VALUES (@TranslatorID, @LanguageID);
END;
GO;