select FirstName + ' ' + LastName             as Student,
           Round(AVG(CONVERT(FLOAT, GradeID)), 2) as AverageGrade
    from Students
             Join dbo.FinalExamGrades FEG on Students.StudentID = FEG.StudentID
    GROUP BY FirstName, LastName
