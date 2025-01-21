SELECT
    Students.StudentID,
    Students.FirstName + ' ' + Students.LastName AS [Student Name],
    SUM(OrderDetails.Amount) AS [Total Order Value],
    COUNT(OrderDetails.OrderDetailsID) AS [Total Products]
FROM
    Students
        JOIN
    Orders ON Students.StudentID = Orders.StudentID
        JOIN
    OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY
    Students.StudentID, Students.FirstName, Students.LastName
