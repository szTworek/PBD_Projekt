CREATE PROCEDURE AddClass
(
    @ClassLecturerID INT,
    @SubjectID INT,
    @Topic VARCHAR(64),
    @Description VARCHAR(MAX),
    @ClassPrice MONEY,
    @Date DATETIME,
    @Duration TIME(0)  ,
    @LanguageID INT,
    @TranslatorID INT,
    @PriceChange REAL,
    @ClassTypeName VARCHAR(32),
    @LimitedPlaces INT,
    @ClassroomID INT = NULL,
    @Link VARCHAR(MAX) = NULL
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
        BEGIN
            RAISERROR ('Subject of ID %d does not exist', 16, 1, @SubjectID);
        END


    IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        BEGIN
            RAISERROR ('Language of ID %d does not exist', 16, 1, @LanguageID);
        END

    IF @TranslatorID IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
            BEGIN
                RAISERROR ('Translator of ID %d does not exist', 16, 1, @TranslatorID);
            END
            IF NOT dbo.IsTranslatorAvailable(@TranslatorID,@Date,@Duration) = 1
                BEGIN
                    RAISERROR ('Translator of ID %d is not available at that time', 16, 1, @TranslatorID);
                END
        END

    IF EXISTS (
            SELECT 1 FROM Classes JOIN ClassLecturers CL on Classes.ClassID = CL.ClassID
            WHERE Topic = @Topic AND ClassDateTime = @Date AND @ClassLecturerID=EmployeeID
        )
            BEGIN
                RAISERROR ('Duplicate class detected', 16, 1);
            END
        DECLARE @ClassTypeID INT;
        IF NOT EXISTS(SELECT 1 FROM ClassTypes WHERE ClassTypeName = @ClassTypeName)
            BEGIN
                RAISERROR('Class type of name %s does not exist',16,1,@ClassTypeName)
            END
        DECLARE @ClassesTable TABLE(ClassID INT);
        SELECT @ClassTypeID = ClassTypeID FROM ClassTypes WHERE ClassTypeName = @ClassTypeName;
        INSERT INTO Classes
        (SubjectID, Topic, Description,  ClassPrice, ClassDateTime, Duration, LanguageID, TranslatorID, PriceChange, ClassTypeID, LimitedPlaces)
        OUTPUT INSERTED.ClassID INTO @ClassesTable
        VALUES (@SubjectID, @Topic, @Description,  @ClassPrice, @Date, @Duration, @LanguageID, @TranslatorID, @PriceChange, @ClassTypeID, @LimitedPlaces);
        DECLARE @ClassID INT;
        SELECT @ClassID = ClassID FROM @ClassesTable;
        IF @ClassTypeID = 1
            BEGIN
                IF NOT dbo.IsClassAvailable(@ClassroomID,@Date,@Duration) = 1
                BEGIN
                    RAISERROR ('Classroom of ID %d is not available at that time', 16, 1, @ClassroomID);
                END
                INSERT INTO OnSiteClasses (ClassID, ClassroomID) VALUES (@ClassID,@ClassroomID);
            END
        IF @ClassTypeID = 2
            BEGIN
                INSERT INTO OnlineSyncClasses (ClassID, Link) VALUES (@ClassID,@Link);
            END
        IF @ClassTypeID = 3
            BEGIN
                INSERT INTO OnlineAsyncClasses (ClassID, Link) VALUES (@ClassID,@Link);
            END
            IF NOT dbo.IsEmployeeAvailable(@ClassLecturerID,@Date,@Duration) = 1
            BEGIN
                RAISERROR ('Employee of ID %d is not available at that time', 16, 1, @ClassLecturerID);
            END
        IF NOT EXISTS (SELECT 1 FROM ClassLecturers WHERE @ClassLecturerID = EmployeeID)
            BEGIN
                EXEC AddClassLecturers @ClassID,@ClassLecturerID;
            END
END
GO;