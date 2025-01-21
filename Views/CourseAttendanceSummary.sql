SELECT C.CourseID, COUNT(CA.StudentID) AS TotalAttendees
FROM Courses C
        JOIN dbo.CourseModules CM on C.CourseID = CM.CourseID
        JOIN CourseAttendances CA ON CM.CourseID = CA.CourseModuleID
GROUP BY C.CourseID
