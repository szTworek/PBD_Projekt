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
