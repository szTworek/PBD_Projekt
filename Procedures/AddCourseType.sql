CREATE PROCEDURE AddCourseType(
    @CourseTypeID INT,
    @CourseName VARCHAR(32)
)
AS
   BEGIN
       INSERT INTO CourseTypes (CourseTypeID, CourseTypeName) VALUES (@CourseTypeID,@CourseName);
   END
GO;
