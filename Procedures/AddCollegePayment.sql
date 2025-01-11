CREATE PROCEDURE AddCollegePayment(
    @SyllabusID INT,
    @StudentID INT
)
AS
BEGIN
    SET NOCOUNT ON;
        -- Check Webinar existence
        IF NOT EXISTS (SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            RAISERROR('Webinar of ID %d does not exist', 16, 1, @SyllabusID);
        END;

        -- Check Student existence
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student of ID %d does not exist', 16, 1, @StudentID);
        END;

        -- Retrieve the Webinar Price
        DECLARE @Price MONEY;
        DECLARE @Tax DECIMAL(5, 2) = 0.32; -- Example tax rate

        SELECT @Price = StudiesEntryFee
        FROM Syllabuses
        WHERE SyllabusID = @SyllabusID;

        -- Validate Webinar Price
        IF @Price IS NULL OR @Price <= 0
        BEGIN
            RAISERROR('Webinar of ID %d has an invalid price', 16, 1, @SyllabusID);
        END;

        -- Declare table variables for capturing inserted IDs
        DECLARE @OrderTable TABLE (OrderID INT);
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);

        -- Insert a new Order and capture the OrderID
        INSERT INTO Orders (StudentID, Status, OrderDate)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, 'paid', GETUTCDATE());

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Insert Order Details and capture the OrderDetailsID
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @Price, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        -- Insert into WebinarPayments
        INSERT INTO CollegeFees (SyllabusID, OrderDetailsID)
        VALUES (@SyllabusID, @OrderDetailsID);

END;
GO