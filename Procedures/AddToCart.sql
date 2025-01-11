CREATE PROCEDURE AddToCart
    @StudentID INT,
    @WebinarID INT = NULL,
    @ClassID INT = NULL,
    @CourseID INT = NULL,
    @SyllabusID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
        DECLARE @Price MONEY = 0;
        DECLARE @Tax DECIMAL(5, 2) = 0.32;

        -- Calculate final price based on provided IDs
        IF @WebinarID IS NOT NULL
        BEGIN
            SELECT @Price += Price
            FROM Webinars
            WHERE WebinarID = @WebinarID;
        END

        IF @ClassID IS NOT NULL
        BEGIN
            SELECT @Price += ClassPrice
            FROM Classes
            WHERE ClassID = @ClassID;
        END

        IF @CourseID IS NOT NULL
        BEGIN
            SELECT @Price += CoursePrice
            FROM Courses
            WHERE CourseID = @CourseID;
        END

        IF @SyllabusID IS NOT NULL
        BEGIN
            SELECT @Price += StudiesEntryFee
            FROM Syllabuses
            WHERE SyllabusID = @SyllabusID;
        END

        -- Validate that price is greater than 0, if it is, notthing was selected
        IF (@Price <= 0)
        BEGIN
            RAISERROR('Price must be greater than 0.', 16, 1);
        END

        -- Insert into Orders and capture OrderID
        DECLARE @OrderTable TABLE (OrderID INT);
        INSERT INTO Orders (StudentID, OrderDate, Status)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, GETUTCDATE(), 'incart');

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Calculate the final amount (price + tax)
        DECLARE @FinalAmount MONEY;
        SET @FinalAmount = @Price + (@Price * @Tax);

        -- Insert into OrderDetails and capture OrderDetailsID
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @FinalAmount, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        -- Insert into respective payment tables
        IF @WebinarID IS NOT NULL
        BEGIN
            INSERT INTO WebinarPayments (WebinarID, OrderDetailsID)
            VALUES (@WebinarID, @OrderDetailsID);
        END

        IF @ClassID IS NOT NULL
        BEGIN
            INSERT INTO ClassesPayments (ClassID, OrderDetailsID)
            VALUES (@ClassID, @OrderDetailsID);
        END

        IF @CourseID IS NOT NULL
        BEGIN
            INSERT INTO CoursePayments (CourseID, OrderDetailsID)
            VALUES (@CourseID, @OrderDetailsID);
        END

        IF @SyllabusID IS NOT NULL
        BEGIN
            INSERT INTO CollegeFees (OrderDetailsID, SyllabusID)
            VALUES (@OrderDetailsID, @SyllabusID);
        END
END;
GO;