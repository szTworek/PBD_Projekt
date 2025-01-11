CREATE PROCEDURE AddCoursePayment(
    @CourseID INT,
    @StudentID INT
)
AS
BEGIN
    SET NOCOUNT ON;

        -- Check Webinar existence
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            RAISERROR('Course of ID %d does not exist', 16, 1, @CourseID);
        END;

        -- Check Student existence
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student of ID %d does not exist', 16, 1, @StudentID);
        END;

        -- Retrieve the Webinar Price
        DECLARE @Price MONEY;
        DECLARE @Tax DECIMAL(5, 2) = 0.32; -- VAT

        SELECT @Price = CoursePrice
        FROM Courses
        WHERE CourseID = @CourseID;

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

        INSERT INTO CoursePayments (CourseID, OrderDetailsID)
        VALUES (@CourseID, @OrderDetailsID);
END;
GO