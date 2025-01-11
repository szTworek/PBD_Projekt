CREATE PROCEDURE AddTranslatorWithLanguages
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Phone NVARCHAR(15),
    @HireDate DATE,
    @Agreement BIT,
    @Languages NVARCHAR(MAX), -- Comma-separated list of languages
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
AS
BEGIN
        DECLARE @AddressID int;
        -- Check if the address exists
        IF NOT EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName
        )
        BEGIN
            -- Call AddAddress to insert the new address
            EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;
        END;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;

        -- Insert new translator
        DECLARE @TranslatorID INT;
        INSERT INTO Translators (FirstName, LastName, AddressID, Phone, HireDate, Agreement)
        VALUES (@FirstName, @LastName, @AddressID, @Phone, @HireDate, @Agreement);

        -- Get the new TranslatorID
        SELECT @TranslatorID = TranslatorID FROM Translators
        WHERE FirstName = @FirstName
        AND LastName = @LastName
        AND AddressID = @AddressID
        AND Phone = @Phone
        AND HireDate = @HireDate;

        -- Split the languages and insert into TranslatorsLanguages
        DECLARE @LanguagesTable TABLE (LanguageName NVARCHAR(127));
        INSERT INTO @LanguagesTable (LanguageName)
        SELECT DISTINCT TRIM(value) AS LanguageName
        FROM STRING_SPLIT(@Languages, ',');

    DECLARE @RowCount INT = (SELECT COUNT(*) FROM @LanguagesTable);

    WHILE @RowCount > 0
        BEGIN
            DECLARE @LanguageName varchar(max);
            SELECT @LanguageName=LanguageName
            FROM @LanguagesTable
            ORDER BY LanguageName DESC OFFSET @RowCount - 1 ROWS FETCH NEXT 1 ROWS ONLY;

            EXEC AddTranslatorsLanguage @TranslatorID, @LanguageName

            SET @RowCount -= 1;
        END
END;
GO