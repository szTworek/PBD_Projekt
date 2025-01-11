CREATE PROCEDURE DeleteStudentFromCollegeClass
    @student_id INT,
    @class_id INT
AS
BEGIN
    IF @student_id NOT IN (SELECT StudentID FROM Students)
        THROW 50000, 'Student not found', 11;

    DELETE CollegeClass WHERE StudentID = @student_id AND CollegeClassID = @class_id;
    DELETE ClassesAttendances WHERE StudentID  = @student_id AND ClassID = @class_id;
    DELETE InternshipsAttendances WHERE StudentID = @student_id;
END
GO;