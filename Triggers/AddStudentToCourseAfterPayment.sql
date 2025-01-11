CREATE TRIGGER AddStudentToCourseAfterPayment
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert webinar availability for paid orders
    INSERT INTO StudentsCourses (StudentID, CourseID)
    SELECT
        i.StudentID,                  -- StudentID from Orders
        cp.CourseID                   -- CourseID from CoursesPayments
    FROM
        inserted i
    INNER JOIN
        OrderDetails od ON i.OrderID = od.OrderID
    INNER JOIN
        CoursePayments cp ON od.OrderDetailsID = cp.OrderDetailsID
    WHERE
        od.OrderID = i.OrderID AND i.Status = 'paid'; -- Validating

END;
GO