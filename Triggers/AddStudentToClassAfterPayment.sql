CREATE TRIGGER AddStudentToClassAfterPayment
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert webinar availability for paid orders
    INSERT INTO StudentsToClass (StudentID, ClassID)
    SELECT
        i.StudentID,                  -- StudentID from Orders
        cp.ClassID                     -- WebinarID from WebinarPayments
    FROM
        inserted i
    INNER JOIN
        OrderDetails od ON i.OrderID = od.OrderID
    INNER JOIN
        ClassesPayments cp ON od.OrderDetailsID = cp.OrderDetailsID
    WHERE
        od.OrderID = i.OrderID AND i.Status = 'paid'; -- Validating

END;
GO