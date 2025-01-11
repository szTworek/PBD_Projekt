CREATE PROCEDURE AddAddress
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
AS
    BEGIN
        DECLARE @CityID INT;

        -- Check if the address already exists
        IF EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE @StreetName = a.StreetName
              AND @Region = a.Region
              AND @CityName = c.CityName
              AND @CountryName = c.CountryName
        )
        BEGIN
            -- Do not throw error, we will get the ID later
            RETURN
        END;
        IF NOT EXISTS (
            SELECT 1
            FROM City c
            WHERE @CityName = c.CityName
            AND   @CountryName = c.CountryName
        )
            BEGIN
                INSERT INTO City (CityName, CountryName)
                VALUES (@CityName, @CountryName);
            END;


        -- Get the CityID
        SELECT @CityID = c.CityID
        FROM City c
        WHERE @CityName = c.CityName
          AND @CountryName = c.CountryName;

        -- Insert the address
        INSERT INTO Addresses (StreetName, Region, CityID)
        VALUES (@StreetName, @Region, @CityID);

    END
GO;
