CREATE FUNCTION WebinarIncomeSumBrutto(
    @WebinarID int
) RETURNS MONEY
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Webinars w WHERE w.WebinarID = @WebinarID )
        RETURN CAST(0 AS MONEY);

    DECLARE @Revenue INT = CAST(0 AS MONEY);
    SELECT @Revenue = SUM(od.Amount)
    FROM Webinars w
    INNER JOIN WebinarPayments wp ON w.WebinarID = wp.WebinarID
    INNER JOIN OrderDetails od ON wp.OrderDetailsID = od.OrderDetailsID WHERE w.WebinarID = @WebinarID;
    IF @Revenue IS NULL
        RETURN CAST(0 AS MONEY);
    RETURN @Revenue;
END;