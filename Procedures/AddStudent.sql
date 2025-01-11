CREATE PROCEDURE AddStudent
(
    @FirstName VARCHAR(64),
    @LastName VARCHAR(64),
    @Phone VARCHAR(16),
    @Agreement BIT,
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
)
AS
BEGIN
    BEGIN
        DECLARE @AddressID INT;

        -- Check if the agreement is accepted
        IF @Agreement != 1
        BEGIN
            RAISERROR ('The agreement must be accepted',16,1);
        END;

        -- Check if the employee already exists
        IF EXISTS (
            SELECT 1
            FROM Students
            WHERE FirstName = @FirstName
              AND LastName = @LastName
              AND Phone = @Phone
        )
        BEGIN
            RAISERROR ('This student already exists',16,1);
        END;

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

        -- Insert the employee into the database
        INSERT INTO Students (FirstName, LastName, AddressID, Phone, Agreement)
        VALUES (@FirstName, @LastName, @AddressID, @Phone, @Agreement);
    END;
END;
GO;