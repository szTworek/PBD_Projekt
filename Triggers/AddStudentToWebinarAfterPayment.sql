CREATE TRIGGER AddStudentToWebinarAfterPayment
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert webinar availability for paid orders
    INSERT INTO WebinarAvailabilities (StudentID, WebinarID, AvailableUntil)
    SELECT
        i.StudentID,                  -- StudentID from Orders
        wp.WebinarID,                 -- WebinarID from WebinarPayments
        DATEADD(DAY, 30, GETUTCDATE()) -- AvailableUntil: 30 days from now
    FROM
        inserted i
    INNER JOIN
        OrderDetails od ON i.OrderID = od.OrderID
    INNER JOIN
        WebinarPayments wp ON od.OrderDetailsID = wp.OrderDetailsID
    WHERE
        od.OrderID = i.OrderID AND i.Status = 'paid'; -- Validating

END;
GO