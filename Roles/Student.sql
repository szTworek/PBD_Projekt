
CREATE ROLE student
GRANT SELECT ON Classes
GRANT SELECT ON Courses 
GRANT SELECT ON CourseModules 
GRANT EXECUTE ON CalculateClassAttendanceForStudent
