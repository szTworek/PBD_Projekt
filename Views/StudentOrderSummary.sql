SELECT O.OrderID, O.StudentID, OD.Amount, OD.Tax
FROM Orders O
         JOIN OrderDetails OD ON O.OrderID = OD.OrderID
