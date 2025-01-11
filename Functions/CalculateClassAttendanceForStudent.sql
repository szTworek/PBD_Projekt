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