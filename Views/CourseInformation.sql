select 
    Courses.CourseID,
    Topic,
    Description,
    CoursePrice as Price,
    PriceChange as [Price change],
    L.LanguageName as Language,
    T.FirstName + ' ' + T.LastName as [Translator],
E.FirstName + ' ' + E.LastName as [Lecturer],
CT.CourseTypeName as [Course type]
from Courses
JOIN dbo.Languages L on L.LanguageID = Courses.LanguageID
JOIN dbo.Translators T on T.TranslatorID = Courses.TranslatorID
JOIN dbo.CourseLecturers CL on Courses.CourseID = CL.CourseID
JOIN dbo.Employees E on E.EmployeeID = CL.LecturerID
JOIN dbo.CourseModules CM on Courses.CourseID = CM.CourseID
JOIN CourseTypes CT on CM.CourseTypeID = CT.CourseTypeID
