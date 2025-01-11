CREATE PROCEDURE AddBaseCourseTypes
AS
BEGIN
    BEGIN TRANSACTION;
    EXEC AddCourseType 1,'onlineasynccourse';
    EXEC AddCourseType 2,'onlinesynccourse';
    EXEC AddCourseType 3,'onsitecourse';
    EXEC AddCourseType 4, 'hybrid';
    COMMIT TRANSACTION;
END;
GO;