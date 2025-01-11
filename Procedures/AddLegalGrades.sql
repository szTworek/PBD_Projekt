CREATE PROCEDURE AddLegalGrades
AS
    BEGIN
        EXEC AddGrade 1,2.0,'niedostateczny';
        EXEC AddGrade 2,3.0,'dostateczny';
        EXEC AddGrade 3,3.5,'plus dostateczny';
        EXEC AddGrade 4,4.0,'dobry';
        EXEC AddGrade 5,4.5, 'plus dobry';
        EXEC AddGrade 6,5.0, 'bardzo dobry';
    END
GO
