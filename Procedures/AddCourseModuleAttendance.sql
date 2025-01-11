CREATE PROCEDURE AddCourseModuleAttendance(
    @CourseModuleID INT,
    @StudentID INT,
    @Attended BIT
)
AS
    BEGIN
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        IF NOT EXISTS(SELECT 1 FROM CourseModules WHERE CourseModuleID = @CourseModuleID)
        BEGIN
            RAISERROR ('Course module of ID %d does not exist', 16, 1, @CourseModuleID);
        END
        INSERT INTO CourseAttendances (StudentID, CourseModuleID, Attended) VALUES (@StudentID,@CourseModuleID,@Attended);
    END
GO;