CREATE PROCEDURE DeleteClass
    @class_id INT
AS BEGIN
    IF @class_id NOT IN (SELECT ClassID FROM Classes)
        THROW 50000, 'Class not found', 11;

    DELETE ClassesAttendances WHERE ClassID = @class_id;
    DELETE OnSiteClasses WHERE ClassID = @class_id;
    DELETE OnlineAsyncClasses WHERE ClassID = @class_id;
    DELETE OnlineSyncClasses WHERE ClassID = @class_id;
    DELETE ClassLeturers WHERE ClassID = @class_id;
    DELETE ClassesPayments WHERE ClassID = @class_id;
    DELETE Classes WHERE ClassID = @class_id;
END
GO;