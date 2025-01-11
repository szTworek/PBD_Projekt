CREATE FUNCTION IsTranslatorAvailable (@TranslatorID INT, @Datetime DATETIME, @Duration TIME(0))
RETURNS BIT
BEGIN
    -- Check if translator exist
    IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
        RETURN CAST(0 AS BIT);

    -- Check if the translator is not assigned to a webinar
    IF EXISTS (SELECT 1 FROM Webinars
                        WHERE TranslatorID = @TranslatorID
                          AND @Datetime BETWEEN WebinarDateTime AND DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), WebinarDateTime))
        RETURN CAST(0 AS BIT);

    -- Check if the translator is not assigned to a course
    IF EXISTS (
        SELECT 1
        FROM CourseModules CM
        INNER JOIN CourseTypes ON CourseTypes.CourseTypeID = CM.CourseTypeID
        INNER JOIN Courses on Courses.CourseID = CM.CourseID
        INNER JOIN CourseModuleMeetings CMM on CM.CourseModuleID = CMM.CourseModuleID
        WHERE TranslatorID = @TranslatorID
        AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) >= CourseDateTime
        AND @Datetime <= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), CourseDateTime)
    )
        RETURN CAST(0 AS BIT);

    -- Check if the translator is not assigned to a class
    IF EXISTS (
        SELECT 1
        FROM Classes
        INNER JOIN ClassTypes ON ClassTypes.ClassTypeID = Classes.ClassTypeID
        WHERE TranslatorID = @TranslatorID
        AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) >= ClassDateTime
        AND @Datetime <= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), ClassDateTime)
        )
        RETURN CAST(0 AS BIT);

    RETURN CAST(1 AS BIT);
END;