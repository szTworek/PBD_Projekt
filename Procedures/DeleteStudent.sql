CREATE PROCEDURE DeleteStudent
    @student_id INT
AS BEGIN
    IF @student_id NOT IN (SELECT StudentID FROM Students)
        THROW 50000, 'Student not found', 11;

    DELETE CollegeClass WHERE StudentID = @student_id;
    DELETE SubjectsGrades WHERE StudentID = @student_id;
    DELETE ClassesAttendances WHERE StudentID  = @student_id;
    DELETE Orders WHERE StudentID  = @student_id;
    DELETE InternshipsAttendances WHERE StudentID = @student_id;
    DELETE Students WHERE StudentID = @student_id;
END
GO;