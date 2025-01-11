CREATE PROCEDURE AddSyllabus
    @Description NVARCHAR(500) = NULL,
    @StudiesEntryFee DECIMAL(19,4),
    @EmployeeID INT,
    @PriceChange DECIMAL(10,4),
    @Edition NVARCHAR(100),
    @StartDate DATE,
    @EndDate DATE,
    @PlaceLimit INT
AS
BEGIN
    -- Check if the employee exists
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        RAISERROR ('Invalid EmployeeID', 16, 1);
    END;

    -- Insert into Syllabuses
    INSERT INTO Syllabuses (Description, StudiesEntryFee, EmployeeID, PriceChange, Edition, StartDate, EndDate, PlaceLimit)
    VALUES (@Description, @StudiesEntryFee, @EmployeeID, @PriceChange, @Edition, @StartDate, @EndDate, @PlaceLimit);
END
GO