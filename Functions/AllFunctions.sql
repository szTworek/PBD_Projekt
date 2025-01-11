CREATE FUNCTION CalculateClassAttendanceForStudent(@StudentID int, @SubjectID int)
RETURNS REAL
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0.0;

    DECLARE @AttendanceCount REAL;
    DECLARE @ClassesCount REAL;

    -- Count attendances
    SELECT @AttendanceCount = COUNT(*)
    FROM ClassesAttendances ca
    INNER JOIN Classes c ON c.ClassID = ca.ClassID
    INNER JOIN Subjects s ON c.SubjectID = s.SubjectID
    WHERE ca.StudentID = @StudentID AND ca.Attended = 1 AND s.SubjectID = @SubjectID;

    -- Count total classes
    SELECT @ClassesCount = COUNT(*)
    FROM ClassesAttendances ca
    INNER JOIN Classes c ON c.ClassID = ca.ClassID
    INNER JOIN Subjects s ON c.SubjectID = s.SubjectID
    WHERE ca.StudentID = @StudentID AND s.SubjectID = @SubjectID;

    -- Return attendance percentage
    IF @ClassesCount = 0 RETURN 0.0;
    RETURN @AttendanceCount / @ClassesCount;
END;
CREATE FUNCTION CalculateCourseAttendanceForStudent(@StudentID INT, @CourseID INT)
RETURNS REAL
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0.0;

    -- Check if Course exists
    IF NOT EXISTS(SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        RETURN 0.0;


    DECLARE @AttendanceCount REAL;
    DECLARE @ModulesCount REAL;

    -- Count Student's attendances for the Course
    SELECT @AttendanceCount = COUNT(*)
    FROM CourseAttendances ca
    INNER JOIN CourseModules cm ON ca.CourseModuleID = cm.CourseModuleID
    INNER JOIN Courses c ON cm.CourseID = c.CourseID
    WHERE Attended = 1 AND StudentID = @StudentID AND c.CourseID = @CourseID;

    -- Count all modules
    SELECT @ModulesCount = COUNT(*)
    FROM Courses c
    INNER JOIN CourseModules cm ON c.CourseID = cm.CourseID
    WHERE c.CourseID = @CourseID;
    -- Return attendance percentage
    IF @ModulesCount = 0 RETURN 0.0;
    RETURN @AttendanceCount / @ModulesCount;

END;

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
CREATE FUNCTION WebinarIncomeSumNetto(
    @WebinarID int
) RETURNS MONEY
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Webinars w WHERE w.WebinarID = @WebinarID )
        RETURN CAST(0 AS MONEY);

    DECLARE @Revenue INT = CAST(0 AS MONEY);
    SELECT @Revenue = SUM(od.Amount*(1-od.Tax))
    FROM Webinars w
    INNER JOIN WebinarPayments wp ON w.WebinarID = wp.WebinarID
    INNER JOIN OrderDetails od ON wp.OrderDetailsID = od.OrderDetailsID WHERE w.WebinarID = @WebinarID;
    IF @Revenue IS NULL
        RETURN CAST(0 AS MONEY);
    RETURN @Revenue;
END;
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
CREATE FUNCTION IsWebinarAvailable(@StudentID INT, @WebinarID INT)
RETURNS BIT
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0;

    -- Check if Webinar exists
    IF NOT EXISTS(SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        RETURN 0;

    -- Check if Webinar is available for the Student
    IF NOT EXISTS(
        SELECT 1
        FROM WebinarAvailabilities wa
        WHERE wa.StudentID = @StudentID
          AND wa.WebinarID = @WebinarID
          AND wa.AvailableUntil >= GETUTCDATE()
    )
        RETURN 0;

    RETURN 1;
END;

