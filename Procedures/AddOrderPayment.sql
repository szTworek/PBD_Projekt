CREATE PROCEDURE AddOrderPayment
    @OrderID INT
AS
    BEGIN
        SET NOCOUNT ON;
        -- Check if the order exists and is in the "incart" status
        IF NOT EXISTS (
            SELECT 1
            FROM Orders
            WHERE OrderID = @OrderID AND Status = 'incart'
        )
        BEGIN
            RAISERROR('Order does not exist or is not in the "incart" status.', 16, 1);
        END

        DECLARE @CurrentTime DATETIME;
        SELECT @CurrentTime = GETUTCDATE(); -- AT TIME ZONE CURRENT_TIMEZONE();

        -- Update the order status to "paid"
        UPDATE Orders
        SET Status = 'paid'
        WHERE OrderID = @OrderID;
        UPDATE Orders
        SET OrderDate = @CurrentTime
        WHERE OrderID = @OrderID;
    END;
GO;