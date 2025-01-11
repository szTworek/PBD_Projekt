CREATE PROCEDURE AddCourseModuleMeeting(
    @CourseModuleID INT,
    @Datetime datetime,
    @Duration time(0),
    @Topic VARCHAR(64),
    @Description VARCHAR(MAX) = NULL,
    @CourseType VARCHAR(64),
    @Link VARCHAR(MAX) = NULL,
    @ClassroomID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

        -- Check if the course module exists
        IF NOT EXISTS(SELECT 1 FROM CourseModules WHERE CourseModuleID = @CourseModuleID)
        BEGIN
            RAISERROR ('Course module of ID %d does not exist', 16, 1, @CourseModuleID);
        END

        -- Check if the translator is available
        DECLARE @TranslatorID INT;
        SELECT @TranslatorID = C.TranslatorID
        FROM Courses C
        JOIN CourseModules CM ON C.CourseID = CM.CourseID
        WHERE CM.CourseModuleID = @CourseModuleID;

        IF (@TranslatorID IS NOT NULL AND dbo.IsLecturerAvailable(@TranslatorID, @Datetime) = 0)
        BEGIN
            RAISERROR ('Translator of ID %d is not available at the specified time', 16, 1, @TranslatorID);
        END

        -- Check if all lecturers for the course are available
        DECLARE @LecturerID INT;
        DECLARE LecturerCursor CURSOR FOR
        SELECT LFC.LecturerID
        FROM CourseLecturers LFC
        JOIN CourseModules CM ON LFC.CourseID = CM.CourseID
        WHERE CM.CourseModuleID = @CourseModuleID;

        OPEN LecturerCursor;
        FETCH NEXT FROM LecturerCursor INTO @LecturerID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF dbo.IsLecturerAvailable(@LecturerID, @Datetime) = 0
            BEGIN
                RAISERROR ('Lecturer of ID %d is not available at the specified time', 16, 1, @LecturerID);
                CLOSE LecturerCursor;
                DEALLOCATE LecturerCursor;
            END
            FETCH NEXT FROM LecturerCursor INTO @LecturerID;
        END
        CLOSE LecturerCursor;
        DEALLOCATE LecturerCursor;

        -- Insert into CourseModuleMeetings
        DECLARE @CourseModuleMeetingIDTable TABLE(CourseModuleMeetingID INT);
        INSERT INTO CourseModuleMeetings (CourseModuleID, CourseDateTime, Duration, Topic, Description)
        OUTPUT INSERTED.CourseModuleMeetingID INTO @CourseModuleMeetingIDTable
        VALUES (@CourseModuleID, @Datetime, @Duration, @Topic, @Description);
        DECLARE @CourseModuleMeetingID INT;
        SELECT @CourseModuleMeetingID = CourseModuleMeetingID FROM @CourseModuleMeetingIDTable;
        DECLARE @CourseTypeID INT;
        SELECT @CourseTypeID = CourseTypeID FROM CourseTypes WHERE CourseTypeName = LOWER(@CourseType);
        -- Handle CourseType-specific tables
        IF @CourseTypeID = 1
        BEGIN
            IF @Link IS NULL
            BEGIN
                RAISERROR ('Link is required for OnlineAsyncCourse', 16, 1);
            END
            INSERT INTO OnlineAsyncCourse (Link, CourseModuleMeetingID)
            VALUES (@Link, @CourseModuleMeetingID);
        END
        ELSE IF @CourseTypeID = 2
        BEGIN
            IF @Link IS NULL
            BEGIN
                RAISERROR ('Link is required for OnlineSyncCourse', 16, 1);
            END
            INSERT INTO OnlineSyncCourse (Link, CourseModuleMeetingID)
            VALUES (@Link, @CourseModuleMeetingID);
        END
        ELSE IF @CourseTypeID = 3
        BEGIN
            IF @ClassroomID IS NULL
            BEGIN
                RAISERROR ('ClassroomID is required for OnSiteCourse', 16, 1);
            END
            INSERT INTO OnSiteCourse (ClassroomID, LimitedPlaces, CourseModuleMeetingID)
            VALUES (@ClassroomID, 0, @CourseModuleMeetingID); -- Adjust LimitedPlaces as needed
        END
        ELSE
        BEGIN
            RAISERROR ('Invalid CourseType: %s', 16, 1, @CourseType);
        END
END;
GO
