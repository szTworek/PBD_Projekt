select 
    CM.CourseID,
    C.Topic,
    CMM.CourseDateTime,
    S.FirstName + ' '+ S.LastName as Student,
    CASE
        WHEN CourseAttendances.Attended = 1 THEN 'Present'
        WHEN CourseAttendances.Attended = 0 THEN 'Absent'
        ELSE 'Unknown'
        END AS [Attendance Status]
    
from CourseAttendances
JOIN dbo.Students S on S.StudentID = CourseAttendances.StudentID
JOIN dbo.CourseModules CM on CM.CourseModuleID = CourseAttendances.CourseModuleID
JOIN dbo.Courses C on C.CourseID = CM.CourseID
JOIN dbo.CourseModuleMeetings CMM on CM.CourseModuleID = CMM.CourseModuleID
