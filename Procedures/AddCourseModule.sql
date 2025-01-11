CREATE PROCEDURE AddCourseModule
    (
        @CourseID INT,
        @CourseType VARCHAR(64)
    )
AS
    BEGIN
        -- Check if the course type exists
        IF NOT EXISTS(SELECT 1 FROM CourseTypes WHERE CourseTypeName = @CourseType)
            BEGIN
                RAISERROR  ('Course %s does not exist', 16,1,@CourseType);
            END
        DECLARE @CourseTypeID INT;
        SELECT @CourseTypeID = CourseTypeID FROM CourseTypes WHERE CourseTypeName = @CourseType;
        INSERT INTO CourseModules (CourseID, CourseTypeID) VALUES (@CourseID, @CourseTypeID);
    END
GO;