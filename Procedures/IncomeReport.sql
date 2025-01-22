CREATE PROCEDURE IncomeReport
AS
BEGIN
    SELECT
        'Webinar' AS Type,
        w.WebinarID AS ActivityID,
        w.WebinarTopic AS ActivityName,
        dbo.WebinarIncomeSumBrutto(w.WebinarID) AS IncomeBrutto,
        dbo.WebinarIncomeSumNetto(w.WebinarID) AS IncomeNetto
    FROM Webinars w
    UNION ALL
    SELECT
        'Course' AS Type,
        c.CourseID AS ActivityID,
        c.Topic AS ActivityName,
        dbo.CourseIncomeSumBrutto(c.CourseID) AS IncomeBrutto,
        dbo.CourseIncomeSumNetto(c.CourseID) AS IncomeNetto
    FROM Courses c
    UNION ALL
    SELECT
        'Class' AS Type,
        cl.ClassID AS ActivityID,
        cl.Topic AS ActivityName,
        dbo.ClassIncomeSumBrutto(cl.ClassID) AS IncomeBrutto,
        dbo.ClassIncomeSumNetto(cl.ClassID) AS IncomeNetto
    FROM Classes cl;
END;
go