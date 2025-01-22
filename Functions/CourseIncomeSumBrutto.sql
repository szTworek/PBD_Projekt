CREATE FUNCTION CourseIncomeSumBrutto(
    @CourseID int
) RETURNS MONEY
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Courses c WHERE c.CourseID = @CourseID)
        RETURN CAST(0 AS MONEY);

    DECLARE @Revenue MONEY = CAST(0 AS MONEY);
    SELECT @Revenue = SUM(od.Amount)
    FROM Courses c
             INNER JOIN CoursePayments cp ON c.CourseID = cp.CourseID
             INNER JOIN OrderDetails od ON cp.OrderDetailsID = od.OrderDetailsID
    WHERE c.CourseID = @CourseID;

    IF @Revenue IS NULL
        RETURN CAST(0 AS MONEY);

    RETURN @Revenue;
END
go