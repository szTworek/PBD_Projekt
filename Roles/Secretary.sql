CREATE ROLE Secretary;

-- Uprawnienia dla "Secretary": zarządzanie zajęciami, przypisywanie studentów, informacje o klasach
GRANT SELECT, INSERT, UPDATE ON dbo.Classes TO Secretary;
GRANT SELECT, INSERT, UPDATE ON dbo.ClassLecturers TO Secretary;
GRANT SELECT, INSERT, UPDATE ON dbo.StudentsToClass TO Secretary;
GRANT SELECT, INSERT, UPDATE ON dbo.ClassesAttendances TO Secretary;
GRANT EXECUTE ON dbo.AddClass TO Secretary;
GRANT EXECUTE ON dbo.AddClassLecturers TO Secretary;
GRANT EXECUTE ON dbo.AddStudentToClass TO Secretary;
GRANT EXECUTE ON dbo.EditClass TO Secretary;
GRANT EXECUTE ON dbo.CalculateClassAttendanceForStudent TO Secretary;
GRANT SELECT ON dbo.ClassInformation TO Secretary;
GRANT SELECT ON dbo.ClassStudentCounts TO Secretary;
GRANT SELECT ON dbo.ClassAttendanceList TO Secretary; 