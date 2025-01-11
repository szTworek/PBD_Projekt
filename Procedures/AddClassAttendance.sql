CREATE PROCEDURE AddClassAttendance(
    @StudentID int,
    @ClassID int,
    @Attendance bit
)
AS
BEGIN
    -- If the student is not signed up to the course the class is taking place in
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
        INSERT INTO ClassesAttendances (ClassID, StudentID, Attended)
        VALUES (@ClassID, @StudentID, @Attendance);
    END
    ELSE
    BEGIN
        RAISERROR ('This attendance already exists, to modify it use EditAttendance',16,1);
    END;
END;
GO;