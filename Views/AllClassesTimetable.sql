CREATE view dbo.AllClassesTimetable as
select Classes.ClassID,
       Topic,
       ClassDateTime as Date,
       Duration,
       CASE
           WHEN CT.ClassTypeName = 'onsitecourse' THEN OSC.ClassroomID
           ELSE null
           END       AS [Classroom],
       CASE
           WHEN CT.ClassTypeName = 'onsitecourse' THEN C.BuildingID
           ELSE null
           END       AS [Building],
       CASE
           WHEN CT.ClassTypeName = 'onlineasynccourse' THEN OAC.Link
           WHEN CT.ClassTypeName = 'onlinesynccourse' THEN O.Link
           ELSE null
           END       AS [Link]
from Classes
         JOIN dbo.Subjects S on S.SubjectID = Classes.SubjectID
         JOIN dbo.ClassTypes CT on CT.ClassTypeID = Classes.ClassTypeID
         left JOIN dbo.OnlineAsyncClasses OAC on Classes.ClassID = OAC.ClassID
         left JOIN dbo.OnlineSyncClasses O on Classes.ClassID = O.ClassID
         left JOIN dbo.OnSiteClasses OSC on Classes.ClassID = OSC.ClassID
         left JOIN dbo.Classrooms C on C.ClassroomID = OSC.ClassroomID
go

grant select on dbo.AllClassesTimetable to Director
go

grant select on dbo.AllClassesTimetable to Lecturer
go