CREATE VIEW ViewWebinarRevenue AS
    SELECT 
        w.WebinarTopic, 
        w.Date, 
        w.WebinarID,  
        SUM(od.Amount) AS Przychód_Brutto, 
        SUM(od.Amount * (1 - od.Tax)) AS Przychód_Netto
    FROM Webinars w
    INNER JOIN WebinarPayments wp ON w.WebinarID = wp.WebinarID
    INNER JOIN OrderDetails od ON wp.OrderDetailsID = od.OrderDetailsID;