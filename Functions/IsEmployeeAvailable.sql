CREATE FUNCTION IsEmployeeAvailable (@EmployeeID INT, @Datetime DATETIME, @Duration TIME(0))
RETURNS BIT
BEGIN
    -- Check if translator exist
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        RETURN 0;

    -- Check if the translator is not assigned to a webinar
    IF EXISTS (SELECT 1 FROM Webinars WHERE EmployeeID = @EmployeeID
        AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) <= WebinarDateTime
        AND @Datetime >= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), WebinarDateTime))
        RETURN 0;

    -- Check if the translator is not assigned to a course
    IF EXISTS (
        SELECT 1
        FROM CourseModules CM
        INNER JOIN CourseTypes ON CourseTypes.CourseTypeID = CM.CourseTypeID
        INNER JOIN Courses ON Courses.CourseID = CM.CourseID
        INNER JOIN CourseModuleMeetings CMM on CM.CourseModuleID = CMM.CourseModuleID
        INNER JOIN CourseLecturers LFC on CM.CourseID = LFC.CourseID
        WHERE LecturerID = @EmployeeID
        AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) >= CourseDateTime
        AND @Datetime <= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), CourseDateTime)
    )
        RETURN 0;

    -- Check if the translator is not assigned to a class
    IF EXISTS (
        SELECT 1
        FROM Classes
        INNER JOIN ClassTypes ON ClassTypes.ClassTypeID = Classes.ClassTypeID
        INNER JOIN ClassLecturers CL on Classes.ClassID = CL.ClassID
        WHERE CL.EmployeeID = @EmployeeID
        AND DATEADD(SECOND, DATEDIFF(SECOND,0,@Duration), @Datetime) >= ClassDateTime
        AND @Datetime <= DATEADD(SECOND, DATEDIFF(SECOND, 0, Duration), ClassDateTime)
    )
        RETURN 0;

    RETURN 1;
END;