CREATE FUNCTION CheckTranslatorLanguage(@TranslatorID int, @LanguageID int)
RETURNS BIT
AS 
BEGIN
	-- Check if translator exists
	IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
		RETURN (0 AS BIT);
	
	-- Check if the language is available 
	IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguagID = @LanguageID)
		RETURN (0 AS BIT);
	
	-- Check if the translator operates with the language
	IF NOT EXISTS (SELECT 1 FROM Translators t INNER JOIN TranslatorLanguages tl 
			WHERE tl.LanguageID = @LanguageID AND t.TranslatorID = @TranslatorID)
		RETURN (0 AS BIT);
	
	RETURN (1 AS BIT);
	-- Czas
END

-- Liczenie 
CREATE FUNCTION GetClassAttendanceForStudent(@StudentID int, @ClassID int)
RETURNS REAL
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0.0;

    -- Check if Class exists
    IF NOT EXISTS(SELECT 1 FROM Classes WHERE ClassID = @ClassID AND Date < GETDATE() )
        RETURN 0.0;

    DECLARE @AttendanceCount INT;
    DECLARE @ClassesCount INT;

    -- Count attendances
    SELECT @AttendanceCount = COUNT(*)
    FROM ClassesAttendances ca
    INNER JOIN Classes c ON ca.ClassID = c.ClassID
    WHERE ca.StudentID = @StudentID AND ca.Attended = 1 AND c.ClassID = @ClassID AND c.Date < GETDATE();

    -- Count total classes
    SELECT @ClassesCount = COUNT(*)
    FROM Classes c
    WHERE c.ClassID = @ClassID AND c.Date < GETDATE();

    -- Return attendance percentage
    IF @ClassesCount = 0 RETURN 0.0;
    RETURN @AttendanceCount / @ClassesCount;
END;

CREATE FUNCTION GetCourseAttendanceForStudent(@StudentID INT, @CourseID INT)
RETURNS REAL
AS
BEGIN
    -- Check if Student exists
    IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        RETURN 0.0;

    -- Check if Course exists
    IF NOT EXISTS(SELECT 1 FROM Courses WHERE CourseID = @CourseID AND Date < GETDATE())
        RETURN 0.0;

    DECLARE @AttendanceCount INT = 0;
    DECLARE @ModulesCount INT = 0;

    -- Count Student's attendances for the Course
    SELECT @AttendanceCount = COUNT(*)
    FROM CourseAttendances ca
    INNER JOIN Courses c ON ca.CourseID = c.CourseID
    WHERE ca.StudentID = @StudentID AND ca.Attended = 1 AND c.CourseID = @CourseID AND c.Date < GETDATE();

    -- Count all Course Modules
    SELECT @ModulesCount = COUNT(*)
    FROM Courses c
    WHERE c.CourseID = @CourseID AND c.Date < GETDATE();

    -- Return attendance percentage
    IF @ModulesCount = 0 RETURN 0.0;
    RETURN CAST(@AttendanceCount AS REAL) / @ModulesCount;
END;
CREATE FUNCTION CheckWebinarAvailability(@StudentID INT, @WebinarID INT)
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
          AND wa.AvailableUntil >= GETDATE()
    )
        RETURN 0;


