select C.CourseID,
           C.Topic,
           CourseDateTime as Date,
           Duration,
           CASE
               WHEN CT.CourseTypeName = 'onsitecourse' THEN OSC.ClassroomID
               ELSE null
               END        AS [Classroom],
           CASE
               WHEN CT.CourseTypeName = 'onsitecourse' THEN C2.BuildingID
               ELSE null
               END        AS [Building],
           CASE
               WHEN CT.CourseTypeName = 'onlineasynccourse' THEN OAC.Link
               WHEN CT.CourseTypeName = 'onlinesynccourse' THEN O.Link
               ELSE null
               END        AS [Link]

    from CourseModuleMeetings
             JOIN dbo.CourseModules CM on CM.CourseModuleID = CourseModuleMeetings.CourseModuleID
             JOIN dbo.Courses C on C.CourseID = CM.CourseID
             left JOIN dbo.OnSiteCourse OSC on CourseModuleMeetings.CourseModuleMeetingID = OSC.CourseModuleMeetingID
             left JOIN dbo.Classrooms C2 on C2.ClassroomID = OSC.ClassroomID
             JOIN dbo.CourseTypes CT on CT.CourseTypeID = CM.CourseTypeID
             Left JOIN dbo.OnlineAsyncCourse OAC
                       on CourseModuleMeetings.CourseModuleMeetingID = OAC.CourseModuleMeetingID
             LEft JOIN dbo.OnlineSyncCourse O on CourseModuleMeetings.CourseModuleMeetingID = O.CourseModuleMeetingID
