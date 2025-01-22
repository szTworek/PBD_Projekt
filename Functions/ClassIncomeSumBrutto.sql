CREATE FUNCTION ClassIncomeSumBrutto(
    @ClassID int
) RETURNS MONEY
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Classes cl WHERE cl.ClassID = @ClassID)
        RETURN CAST(0 AS MONEY);

    DECLARE @Revenue MONEY = CAST(0 AS MONEY);
    SELECT @Revenue = SUM(od.Amount)
    FROM Classes cl
             INNER JOIN ClassesPayments cp ON cl.ClassID = cp.ClassID
             INNER JOIN OrderDetails od ON cp.OrderDetailsID = od.OrderDetailsID
    WHERE cl.ClassID = @ClassID;

    IF @Revenue IS NULL
        RETURN CAST(0 AS MONEY);

    RETURN @Revenue;
END
go