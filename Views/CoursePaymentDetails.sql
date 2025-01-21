SELECT CP.OrderDetailsID, O.StudentID, CP.CourseID, OD.Amount
FROM CoursePayments CP
         JOIN OrderDetails OD ON CP.OrderDetailsID = OD.OrderDetailsID
         JOIN Orders O ON OD.OrderID = O.OrderID
