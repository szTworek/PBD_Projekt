CREATE ROLE Lecturer;

-- Uprawnienia dla "Lecturer": zarządzanie tabelami związanymi z klasami, kursami, obecnościami na zajęciach i ocenami
GRANT SELECT ON dbo.Classes TO Lecturer;
GRANT SELECT ON dbo.ClassLecturers TO Lecturer;
GRANT SELECT ON dbo.Syllabuses TO Lecturer;
GRANT SELECT ON dbo.Courses TO Lecturer;
GRANT SELECT ON dbo.CourseModuleMeetings TO Lecturer;
GRANT SELECT ON dbo.CourseModules TO Lecturer;
GRANT SELECT ON dbo.AllClassesTimetable TO Lecturer;
GRANT SELECT ON dbo.AllCoursesTimetable TO Lecturer;
GRANT SELECT ON dbo.AverageGrades TO Lecturer;
GRANT SELECT ON dbo.CourseInformation TO Lecturer;
GRANT SELECT ON dbo.CourseAttendanceList TO Lecturer;
GRANT SELECT ON dbo.CourseAttendanceSummary TO Lecturer;
GRANT SELECT ON dbo.ClassInformation TO Lecturer;
GRANT SELECT ON dbo.ClassAttendanceList TO Lecturer;
GRANT EXECUTE ON dbo.AddGrade TO Lecturer;
GRANT EXECUTE ON dbo.EditSubjectGrade TO Lecturer;
GRANT EXECUTE ON dbo.AddSubjectsGrade TO Lecturer;
GRANT EXECUTE ON dbo.AddClassAttendance TO Lecturer;
GRANT EXECUTE ON dbo.AddCourseModuleAttendance TO Lecturer;
GRANT EXECUTE ON dbo.AddFinalExamGrade TO Lecturer;
GRANT SELECT ON dbo.ClassStudentCounts TO Lecturer;
GRANT SELECT ON dbo.BuildingsAndClassrooms TO Lecturer; 