CREATE PROCEDURE EditClassAttendance
    (
    @StudentID int,
    @ClassID int,
    @Attendance bit
    )
AS
        IF NOT EXISTS(
            SELECT 1
            FROM Students s
            INNER JOIN CollegeClass cc ON cc.StudentID = s.StudentID
            INNER JOIN Syllabuses sy ON cc.SyllabusID = sy.SyllabusID
            INNER JOIN Subjects su ON  su.SyllabusID = sy.SyllabusID
            INNER JOIN Classes c ON c.SubjectID = su.SubjectID
            WHERE c.ClassID = @ClassID AND s.StudentID = @StudentID
            ) AND NOT EXISTS(SELECT 1
                             FROM Students s
                             INNER JOIN StudentsToClass stc ON s.StudentID = stc.StudentID
                             WHERE stc.ClassID = @ClassID)
    BEGIN
        RAISERROR ('Student is not signed up for this class',16,1);
    END;
    -- If the attendance was not created
    IF NOT EXISTS (
        SELECT 1
        FROM ClassesAttendances
        WHERE ClassID = @ClassID AND StudentID = @StudentID
    )
    BEGIN
        RAISERROR ('This attendance does not exist, use AddClassAttendance to create it',16,1)
    END
            -- Update if attendance already exists, that is if that's an excused absence or there has been an error
        UPDATE ClassesAttendances
        SET Attended = @Attendance
        WHERE ClassID = @ClassID AND StudentID = @StudentID;
    GO