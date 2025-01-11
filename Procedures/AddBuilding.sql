CREATE PROCEDURE AddBuilding(
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
)
AS
        BEGIN
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
        DECLARE @AddressID INT;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;
            INSERT INTO Buildings (AddressID) VALUES (@AddressID)
    END;
GO