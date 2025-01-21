select
    S.FirstName + ' '+ S.LastName as Student,
    I.StartDate as [Start date],
    InternshipsAttendances.InternshipDay as Day,
    CASE
        WHEN InternshipsAttendances.Attended = 1 THEN 'Present'
        WHEN InternshipsAttendances.Attended = 0 THEN 'Absent'
        ELSE 'Unknown'
        END AS [Attendance Status]
from InternshipsAttendances
JOIN dbo.Internships I on I.InternshipID = InternshipsAttendances.InternshipID
Join dbo.Students S on InternshipsAttendances.StudentID = S.StudentID
