CREATE PROCEDURE EditStudent
    @StudentID INT,
    @FirstName VARCHAR(64) = NULL,
    @LastName VARCHAR(64) = NULL,
    @Phone VARCHAR(9) = NULL,
    @StreetName VARCHAR(32) = NULL,
    @Region VARCHAR(32) = NULL,
    @CityName VARCHAR(32) = NULL,
    @CountryName VARCHAR(32) = NULL

AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        THROW 50001, 'StudentID does not exist.', 1;

    DECLARE @AddressID INT;

    IF (@StreetName IS NOT NULL OR @Region IS NOT NULL OR @CityName IS NOT NULL OR @CountryName IS NOT NULL)
        BEGIN
            IF (@StreetName IS NULL OR @Region IS NULL OR @CityName IS NULL OR @CountryName IS NULL)
                THROW 50005, 'All address fields must be provided', 1;

            IF NOT EXISTS (
                SELECT 1
                FROM Addresses a
                         INNER JOIN City c ON a.CityID = c.CityID
                WHERE a.StreetName = @StreetName
                  AND a.Region = @Region
                  AND c.CityName = @CityName
                  AND c.CountryName = @CountryName
            ) EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;

            SELECT @AddressID = a.AddressID
            FROM Addresses a
                     INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName;
        END

    BEGIN TRY

        UPDATE Students
        SET
            FirstName = ISNULL(@FirstName, FirstName),
            LastName = ISNULL(@LastName, LastName),
            AddressID = ISNULL(@AddressID, AddressID),
            Phone = ISNULL(@Phone, Phone)
        WHERE StudentID = @StudentID;

        PRINT 'Student information updated.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred:';
        PRINT ERROR_MESSAGE();
    END CATCH

END;
go

grant execute on dbo.EditStudent to Director
go

