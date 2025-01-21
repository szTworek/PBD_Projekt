select 
    C.ClassID,
    S2.SubjectName,
C.Topic,
C.ClassDateTime,
    S.FirstName + ' '+ S.LastName as Student,
    CASE
        WHEN ClassesAttendances.Attended = 1 THEN 'Present'
        WHEN ClassesAttendances.Attended = 0 THEN 'Absent'
        ELSE 'Unknown'
        END AS [Attendance Status]
from ClassesAttendances
JOIN dbo.Classes C on C.ClassID = ClassesAttendances.ClassID
JOIN dbo.Students S on S.StudentID = ClassesAttendances.StudentID
JOIN dbo.Subjects S2 on S2.SubjectID = C.SubjectID
