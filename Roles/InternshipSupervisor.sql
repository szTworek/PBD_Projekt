CREATE ROLE InternshipSupervisor;

-- Uprawnienia dla "InternshipSupervisor": zarządzanie stażami i ich uczestnikami
Grant SELECT ON dbo.Students TO InternshipSupervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Internships TO InternshipSupervisor;
GRANT SELECT ON dbo.InternshipsAttendances TO InternshipSupervisor;
GRANT EXECUTE ON dbo.AddInternship TO InternshipSupervisor;
GRANT EXECUTE ON dbo.AddInternshipAttendance TO InternshipSupervisor;
GRANT EXECUTE ON dbo.EditInternshipAttendance TO InternshipSupervisor;
GRANT SELECT ON dbo.InternshipAttendanceList TO InternshipSupervisor;
GRANT SELECT ON dbo.InternshipParticipants TO InternshipSupervisor;