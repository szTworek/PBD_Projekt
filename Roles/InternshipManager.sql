CREATE ROLE InternshipManager
GRANT SELECT, INSERT, UPDATE ON InternshipAttendances TO InternshipManager
GRANT SELECT, INSERT, UPDATE ON Internships TO InternshipManager
GRANT EXECUTE ON AddInternship TO InternshipManager 
GRANT EXECUTE ON AddInternshipAttendance TO InternshipManager 
