CREATE FUNCTION IsClassAvailable (
    @ClassroomID INT,
    @Datetime DATETIME,
    @Duration TIME(0)
) RETURNS BIT
BEGIN
    -- Classroom does not exist
    IF NOT EXISTS(SELECT 1 FROM Classrooms WHERE ClassroomID = @ClassroomID)
    BEGIN
        RETURN CAST(0 AS BIT);
    END

    -- Classroom is occupied by a course meeting
    IF EXISTS(SELECT 1 FROM OnSiteCourse INNER JOIN CourseModuleMeetings CMM
            ON OnSiteCourse.CourseModuleMeetingID = CMM.CourseModuleMeetingID
            WHERE ClassroomID = @ClassroomID
            AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) <= CourseDateTime
            AND @Datetime >= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), CourseDateTime))
    BEGIN
        RETURN CAST(0 AS BIT)
    END
    -- Classroom is occupied by a class meeting
    IF EXISTS(SELECT 1 FROM Classes JOIN OnSiteClasses OSC
        ON Classes.ClassID = OSC.ClassID
        WHERE ClassroomID = @ClassroomID
            AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) <= ClassDateTime
            AND @Datetime >= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), ClassDateTime))
    BEGIN
        RETURN CAST(0 AS BIT)
    END
    RETURN CAST(1 AS BIT);
END;