CREATE ROLE Accountant;

-- Uprawnienia dla "Accountant": zarządzanie zamówieniami, płatnościami, raporty finansowe
GRANT SELECT, INSERT, UPDATE ON dbo.Orders TO Accountant;
GRANT SELECT, INSERT, UPDATE ON dbo.OrderDetails TO Accountant;
GRANT SELECT, INSERT, UPDATE ON dbo.CoursePayments TO Accountant;
GRANT SELECT, INSERT, UPDATE ON dbo.WebinarPayments TO Accountant;
GRANT SELECT, INSERT, UPDATE ON dbo.ClassesPayments TO Accountant;
GRANT EXECUTE ON dbo.AddOrderPayment TO Accountant;
GRANT EXECUTE ON dbo.IncomeReport TO Accountant;
GRANT EXECUTE ON dbo.WebinarIncomeSumBrutto TO Accountant;
GRANT EXECUTE ON dbo.WebinarIncomeSumNetto TO Accountant;
GRANT EXECUTE ON dbo.ClassIncomeSumBrutto TO Accountant;
GRANT EXECUTE ON dbo.ClassIncomeSumNetto TO Accountant;
GRANT EXECUTE ON dbo.CourseIncomeSumBrutto TO Accountant;
GRANT EXECUTE ON dbo.CourseIncomeSumNetto TO Accountant;
GRANT SELECT ON dbo.StudentOrderSummary TO Accountant;
GRANT SELECT ON dbo.StudentOrdersDetails TO Accountant;
GRANT SELECT ON dbo.CoursePaymentDetails TO Accountant;