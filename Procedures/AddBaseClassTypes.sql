CREATE PROCEDURE AddBaseClassTypes
AS
BEGIN
    EXEC AddClassType 1,'onsiteclasses';
    EXEC AddClassType 2,'onlinesyncclasses';
    EXEC AddClassType 3,'onlineasyncclasses';
END;
GO;