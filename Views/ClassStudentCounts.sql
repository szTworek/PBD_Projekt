SELECT C.ClassID, COUNT(SC.StudentID) AS TotalStudents
FROM Classes C
         JOIN StudentsToClass SC ON C.ClassID = SC.ClassID
GROUP BY C.ClassID
