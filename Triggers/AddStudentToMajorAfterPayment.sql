CREATE TRIGGER AddStudentToMajorAfterPayment
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert webinar availability for paid orders
    INSERT INTO CollegeClass (StudentID, SyllabusID)
    SELECT
        i.StudentID,                  -- StudentID from Orders
        cf.SyllabusID -- SyllabusID from CollegeFees
    FROM
        inserted i
    INNER JOIN
        OrderDetails od ON i.OrderID = od.OrderID
    INNER JOIN
        CollegeFees cf ON od.OrderDetailsID = cf.OrderDetailsID
    WHERE
        od.OrderID = i.OrderID AND i.Status = 'paid'; -- Validating

END;
GO