CREATE PROCEDURE AddWebinar
    (
        @EmployeeID INT,
        @TranslatorID INT = NULL,
        @WebinarTopic VARCHAR(64),
        @Description VARCHAR(MAX) = NULL,
        @Price MONEY,
        @WebinarDate DATETIME,
        @Duration TIME(0),
        @LanguageID INT,
        @Link VARCHAR(MAX)
    )
AS
    BEGIN
            -- Check if Language exists
            IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
            BEGIN
                RAISERROR ('Language of ID %d does not exist', 16, 1, @LanguageID);
            END

            -- Check if Employee exists
            IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
            BEGIN
                RAISERROR ('Employee of ID %d does not exist', 16, 1, @EmployeeID);
            END
            IF NOT dbo.IsEmployeeAvailable(@EmployeeID, @WebinarDate,@WebinarDate) = 1
            BEGIN
                RAISERROR ('Employee of ID %d is not available at that time', 16, 1, @EmployeeID);
            END
            -- Check if Translator exists, if provided
            IF @TranslatorID IS NOT NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
                BEGIN
                    RAISERROR ('Translator of ID %d does not exist', 16, 1, @TranslatorID);
                END
                IF NOT dbo.IsTranslatorAvailable(@TranslatorID, @WebinarDate,@WebinarDate) = 1
                BEGIN
                    RAISERROR ('Translator of ID %d is not available at that time', 16, 1, @TranslatorID);
                END
            END

            -- Prevent duplicate webinars
            IF EXISTS (
                SELECT 1 FROM Webinars
                WHERE WebinarTopic = @WebinarTopic AND WebinarDateTime =  @WebinarDate AND Link = @Link
            )
            BEGIN
                RAISERROR ('Duplicate webinar detected', 16, 1);
            END

            -- Insert the webinar
            INSERT INTO Webinars
            (EmployeeID, TranslatorID, WebinarTopic, Description, Price, WebinarDateTime, Duration, LanguageID, Link)
            VALUES (@EmployeeID, @TranslatorID, @WebinarTopic, @Description, @Price, @WebinarDate, @Duration, @LanguageID, @Link);
    END;
GO