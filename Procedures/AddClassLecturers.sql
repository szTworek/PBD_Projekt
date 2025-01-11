CREATE PROCEDURE AddClassLecturers(
    @ClassID INT,
    @EmployeeID INT
)
AS
    BEGIN
        BEGIN TRANSACTION;
        -- Check if Employee exists
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
            BEGIN
                RAISERROR ('Employee of ID %d does not exist', 16, 1, @EmployeeID);
            END
        -- Check if Class exists
        IF NOT EXISTS (SELECT 1 FROM Classes WHERE ClassID = @ClassID)
            BEGIN
                RAISERROR ('Class of ID %d does not exist', 16, 1, @ClassID);
            END
        INSERT INTO ClassLeturers (EmployeeID, ClassID) VALUES (@EmployeeID, @ClassID);
        COMMIT TRANSACTION;
    END
GO
