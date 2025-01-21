CREATE ROLE Student;

-- Uprawnienia dla "Student": przeglądanie własnych danych, dostęp do tabel Grades, Classes, Syllabuses
GRANT SELECT ON dbo.Students TO Student;
GRANT SELECT ON dbo.Grades TO Student;
GRANT SELECT ON dbo.Classes TO Student;
GRANT SELECT ON dbo.Syllabuses TO Student;
GRANT EXECUTE ON dbo.CalculateClassAttendanceForStudent TO Student;
GRANT EXECUTE ON dbo.CalculateCourseAttendanceForStudent TO Student;