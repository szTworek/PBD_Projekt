CREATE PROCEDURE AddSubjectsGrade(
    @StudentID INT,
    @GradeValue DECIMAL(2,1),
    @SubjectID INT
)
AS
    BEGIN
        -- Check if subject exists
        IF NOT EXISTS(SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
            BEGIN
                RAISERROR ('Subject of ID %d does not exist', 16, 1, @SubjectID);
            END
        -- Check if grade exists
        IF NOT EXISTS(SELECT 1 FROM Grades WHERE GradeValue = @GradeValue)
            BEGIN
                DECLARE @GradeValueString VARCHAR(10) = @GradeValue;
                RAISERROR ('Grade of value %s does not exist', 16, 1, @GradeValueString);
            END
        DECLARE @GradeID INT;
        SELECT @GradeID = GradeID FROM Grades WHERE GradeValue = @GradeValue;
        INSERT INTO SubjectsGrades (GradeID, StudentID, SubjectID) VALUES (@GradeID,@StudentID,@SubjectID);
    END
GO
CREATE PROCEDURE DeleteStudent
    @student_id INT
AS BEGIN
    IF @student_id NOT IN (SELECT StudentID FROM Students)
        THROW 50000, 'Student not found', 11;

    DELETE CollegeClass WHERE StudentID = @student_id;
    DELETE SubjectsGrades WHERE StudentID = @student_id;
    DELETE ClassesAttendances WHERE StudentID  = @student_id;
    DELETE Orders WHERE StudentID  = @student_id;
    DELETE InternshipsAttendances WHERE StudentID = @student_id;
    DELETE Students WHERE StudentID = @student_id;
END
GO;
CREATE PROCEDURE AddBuilding(
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
)
AS
        BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName
        )
        BEGIN
            -- Call AddAddress to insert the new address
            EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;
        END;
        DECLARE @AddressID INT;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;
            INSERT INTO Buildings (AddressID) VALUES (@AddressID)
    END;
GO
CREATE PROCEDURE AddStudentToWebinar(
    @StudentID INT,
    @WebinarID INT,
    @Date DATE
)
AS
    BEGIN
        -- Check if the student exists
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        -- Check if the course exists
        IF NOT EXISTS(SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        BEGIN
            RAISERROR ('Webinar of ID %d does not exist', 16, 1, @WebinarID);
        END
        -- To be discussed, as it could be an exception procedure, the trigger handles adding student after payment
        -- IF NOT EXISTS(
        --     SELECT 1
        --     FROM Orders o
        --     INNER JOIN Students s ON o.StudentID = s.StudentID
        --     INNER JOIN OrderDetails od ON od.OrderID = o.OrderID
        --     INNER JOIN WebinarPayments wp ON wp.OrderDetailsID = od.OrderDetailsID
        --     WHERE wp.WebinarID = @WebinarID AND o.StudentID = @StudentID
        -- )
        -- BEGIN
        --     RAISERROR ('Student has not paid for the course', 16, 1);
        -- END;
        INSERT INTO WebinarAvailabilities (StudentID, WebinarID,AvailableUntil) VALUES (@StudentID,@WebinarID, @Date);
    END
GO;
CREATE PROCEDURE AddClassLecturers(
    @ClassID INT,
    @EmployeeID INT
)
AS
    BEGIN
        BEGIN TRANSACTION;
        -- Check if Employee exists
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
            BEGIN
                RAISERROR ('Employee of ID %d does not exist', 16, 1, @EmployeeID);
            END
        -- Check if Class exists
        IF NOT EXISTS (SELECT 1 FROM Classes WHERE ClassID = @ClassID)
            BEGIN
                RAISERROR ('Class of ID %d does not exist', 16, 1, @ClassID);
            END
        INSERT INTO ClassLeturers (EmployeeID, ClassID) VALUES (@EmployeeID, @ClassID);
        COMMIT TRANSACTION;
    END
GO

CREATE PROCEDURE AddAddress
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
AS
    BEGIN
        DECLARE @CityID INT;

        -- Check if the address already exists
        IF EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE @StreetName = a.StreetName
              AND @Region = a.Region
              AND @CityName = c.CityName
              AND @CountryName = c.CountryName
        )
        BEGIN
            -- Do not throw error, we will get the ID later
            RETURN
        END;
        IF NOT EXISTS (
            SELECT 1
            FROM City c
            WHERE @CityName = c.CityName
            AND   @CountryName = c.CountryName
        )
            BEGIN
                INSERT INTO City (CityName, CountryName)
                VALUES (@CityName, @CountryName);
            END;


        -- Get the CityID
        SELECT @CityID = c.CityID
        FROM City c
        WHERE @CityName = c.CityName
          AND @CountryName = c.CountryName;

        -- Insert the address
        INSERT INTO Addresses (StreetName, Region, CityID)
        VALUES (@StreetName, @Region, @CityID);

    END
GO;

CREATE PROCEDURE AddEmployee
(
    @FirstName VARCHAR(64),
    @LastName VARCHAR(64),
    @HireDate DATE,
    @Phone VARCHAR(16),
    @Role VARCHAR(64),
    @Agreement BIT,
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
)
AS
BEGIN
    BEGIN
        DECLARE @AddressID INT;

        -- Check if the agreement is accepted
        IF @Agreement != 1
        BEGIN
            RAISERROR ('The agreement must be accepted',16,1);
        END;

        -- Check if the employee already exists
        IF EXISTS (
            SELECT 1
            FROM Employees
            WHERE FirstName = @FirstName
              AND LastName = @LastName
              AND Phone = @Phone
        )
        BEGIN
            RAISERROR ('This employee already exists',16,1);
        END;

        -- Check if the address exists
        IF NOT EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName
        )
        BEGIN
            -- Call AddAddress to insert the new address
            EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;
        END;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;

        IF NOT EXISTS(
            SELECT 1
            FROM EmployeesRoles
            WHERE Role = @Role
        )
        BEGIN
            -- Call AddRole to insert the new role
            EXEC AddRole @Role, 'Role created automatically by AddEmployee';
        END;
        -- Insert the employee into the database
        INSERT INTO Employees (FirstName, LastName, AddressID, Phone, HireDate, Role, Agreement)
        VALUES (@FirstName, @LastName, @AddressID, @Phone, @HireDate, @Role,@Agreement);
    END;
END;
GO;
CREATE PROCEDURE EditClassAttendance
    (
    @StudentID int,
    @ClassID int,
    @Attendance bit
    )
AS
        IF NOT EXISTS(
            SELECT 1
            FROM Students s
            INNER JOIN CollegeClass cc ON cc.StudentID = s.StudentID
            INNER JOIN Syllabuses sy ON cc.SyllabusID = sy.SyllabusID
            INNER JOIN Subjects su ON  su.SyllabusID = sy.SyllabusID
            INNER JOIN Classes c ON c.SubjectID = su.SubjectID
            WHERE c.ClassID = @ClassID AND s.StudentID = @StudentID
            ) AND NOT EXISTS(SELECT 1
                             FROM Students s
                             INNER JOIN StudentsToClass stc ON s.StudentID = stc.StudentID
                             WHERE stc.ClassID = @ClassID)
    BEGIN
        RAISERROR ('Student is not signed up for this class',16,1);
    END;
    -- If the attendance was not created
    IF NOT EXISTS (
        SELECT 1
        FROM ClassesAttendances
        WHERE ClassID = @ClassID AND StudentID = @StudentID
    )
    BEGIN
        RAISERROR ('This attendance does not exist, use AddClassAttendance to create it',16,1)
    END
            -- Update if attendance already exists, that is if that's an excused absence or there has been an error
        UPDATE ClassesAttendances
        SET Attended = @Attendance
        WHERE ClassID = @ClassID AND StudentID = @StudentID;
    GO
CREATE PROCEDURE AddCourse
    (
        @Topic VARCHAR(64),
        @ClassLecturerID INT,
        @CoursePrice MONEY,
        @Language VARCHAR(32),
        @PriceChange REAL,
        @TranslatorID INT = NULL,
        @Description VARCHAR(MAX) = NULL
    )
AS
    BEGIN
        -- Check if translator exists
        IF @TranslatorID IS NOT NULL
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
            BEGIN
                RAISERROR ('Translator of ID %d does not exist', 16,1,@TranslatorID);
            END
        END
        -- Check if employee exists
        IF NOT EXISTS(SELECT 1 FROM Employees WHERE EmployeeID = @ClassLecturerID)
            BEGIN
                RAISERROR  ('Employee of ID %d does not exist', 16,1,@ClassLecturerID);
            END
        -- Check if the language exists
        IF NOT EXISTS(SELECT 1 FROM Languages WHERE LanguageName = @Language)
            BEGIN
                RAISERROR  ('Language %s does not exist', 16,1,@Language);
            END
        DECLARE @LanguageID INT;
        SELECT @LanguageID = LanguageID FROM Languages WHERE LanguageName = @Language;
        DECLARE @CourseTable TABLE(CourseID INT);
        INSERT INTO Courses (Topic,Description,CoursePrice,LanguageID,PriceChange,TranslatorID)
        OUTPUT INSERTED.CourseID INTO @CourseTable
        VALUES (@Topic,@Description,@coursePrice, @LanguageID, @PriceChange,@TranslatorID)
        DECLARE @CourseID INT;
        SELECT @CourseID = CourseID FROM @CourseTable;
        INSERT INTO CourseLecturers (LecturerID, CourseID) VALUES (@ClassLecturerID, @CourseID);
    END
GO;

CREATE PROCEDURE AddInternship(
    @StartDate DATE,
    @SyllabusID INT,
    @InternshipDays INT = 14
)
AS
BEGIN
    BEGIN TRANSACTION;
    -- Check if syllabus exists
    IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
    INSERT INTO Internships (StartDate, InternshipDays, SyllabusID) VALUES (@StartDate, @InternshipDays, @SyllabusID)
    COMMIT TRANSACTION;
END
GO;

CREATE PROCEDURE AddInternshipAttendance(
    @StudentID INT,
    @InternshipID INT,
    @InternshipDay INT,
    @Attendance BIT
)

AS
    BEGIN
        BEGIN TRANSACTION;
        -- Check if syllabus exists
        IF NOT EXISTS(SELECT 1 FROM Internships WHERE InternshipID = @InternshipID)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Internship of ID %d does not exist', 16, 1, @InternshipID);
        END
            -- Check if student exists
        IF NOT EXISTS (
        SELECT 1
        FROM InternshipsAttendances
        WHERE InternshipID = @InternshipID AND StudentID = @StudentID
    )
    BEGIN
        INSERT INTO InternshipsAttendances (StudentID, InternshipID, InternshipDay, Attended)
        VALUES (@StudentID, @InternshipID,@InternshipDay, @Attendance);
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('This attendance already exists, to modify it use EditAttendance',16,1);
    END;
    COMMIT TRANSACTION;
    END
GO;
CREATE PROCEDURE AddCoursePayment(
    @CourseID INT,
    @StudentID INT
)
AS
BEGIN
    SET NOCOUNT ON;

        -- Check Webinar existence
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            RAISERROR('Course of ID %d does not exist', 16, 1, @CourseID);
        END;

        -- Check Student existence
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student of ID %d does not exist', 16, 1, @StudentID);
        END;

        -- Retrieve the Webinar Price
        DECLARE @Price MONEY;
        DECLARE @Tax DECIMAL(5, 2) = 0.32; -- VAT

        SELECT @Price = CoursePrice
        FROM Courses
        WHERE CourseID = @CourseID;

        -- Declare table variables for capturing inserted IDs
        DECLARE @OrderTable TABLE (OrderID INT);
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);

        -- Insert a new Order and capture the OrderID
        INSERT INTO Orders (StudentID, Status, OrderDate)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, 'paid', GETUTCDATE());

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Insert Order Details and capture the OrderDetailsID
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @Price, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        INSERT INTO CoursePayments (CourseID, OrderDetailsID)
        VALUES (@CourseID, @OrderDetailsID);
END;
GO
CREATE PROCEDURE AddCourseModuleAttendance(
    @CourseModuleID INT,
    @StudentID INT,
    @Attended BIT
)
AS
    BEGIN
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        IF NOT EXISTS(SELECT 1 FROM CourseModules WHERE CourseModuleID = @CourseModuleID)
        BEGIN
            RAISERROR ('Course module of ID %d does not exist', 16, 1, @CourseModuleID);
        END
        INSERT INTO CourseAttendances (StudentID, CourseModuleID, Attended) VALUES (@StudentID,@CourseModuleID,@Attended);
    END
GO;
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
CREATE PROCEDURE AddBaseClassTypes
AS
BEGIN
    EXEC AddClassType 1,'onsiteclasses';
    EXEC AddClassType 2,'onlinesyncclasses';
    EXEC AddClassType 3,'onlineasyncclasses';
END;
GO;
CREATE PROCEDURE AddTranslatorsLanguage
    @TranslatorID INT,
    @LanguageName NVARCHAR(127)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @LanguageID INT;

    SELECT @LanguageID = LanguageID
    FROM Languages
    WHERE LanguageName = @LanguageName;

    -- Add language
    IF @LanguageID IS NULL
    BEGIN
        INSERT INTO Languages (LanguageName)
        VALUES (@LanguageName);
        SELECT @LanguageID = LanguageID FROM Languages WHERE LanguageName = @LanguageName;
    END

    INSERT INTO TranslatorsLanguages (TranslatorID, LanguageID)
    VALUES (@TranslatorID, @LanguageID);
END;
GO;
CREATE PROCEDURE AddRole
    @Role VARCHAR(64),
    @RoleDescription varchar(max)
AS
BEGIN
    BEGIN
        -- Check if the role already exists
        IF EXISTS (
            SELECT 1
            FROM EmployeesRoles er
            WHERE @Role = er.Role
        )
        BEGIN
            RAISERROR ('The role already exists.' , 16, 1);
        END;

        INSERT INTO EmployeesRoles (Role, Description)
        VALUES (@Role, @RoleDescription);
    END;
END;
GO;
CREATE PROCEDURE AddClassAttendance(
    @StudentID int,
    @ClassID int,
    @Attendance bit
)
AS
BEGIN
    -- If the student is not signed up to the course the class is taking place in
    IF NOT EXISTS(
            SELECT 1
            FROM Students s
            INNER JOIN CollegeClass cc ON cc.StudentID = s.StudentID
            INNER JOIN Syllabuses sy ON cc.SyllabusID = sy.SyllabusID
            INNER JOIN Subjects su ON  su.SyllabusID = sy.SyllabusID
            INNER JOIN Classes c ON c.SubjectID = su.SubjectID
            WHERE c.ClassID = @ClassID AND s.StudentID = @StudentID
            ) AND NOT EXISTS(SELECT 1
                             FROM Students s
                             INNER JOIN StudentsToClass stc ON s.StudentID = stc.StudentID
                             WHERE stc.ClassID = @ClassID)
    BEGIN
        RAISERROR ('Student is not signed up for this class',16,1);
    END;
    -- If the attendance was not created
    IF NOT EXISTS (
        SELECT 1
        FROM ClassesAttendances
        WHERE ClassID = @ClassID AND StudentID = @StudentID
    )
    BEGIN
        INSERT INTO ClassesAttendances (ClassID, StudentID, Attended)
        VALUES (@ClassID, @StudentID, @Attendance);
    END
    ELSE
    BEGIN
        RAISERROR ('This attendance already exists, to modify it use EditAttendance',16,1);
    END;
END;
GO;
CREATE PROCEDURE AddTranslatorWithLanguages
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Phone NVARCHAR(15),
    @HireDate DATE,
    @Agreement BIT,
    @Languages NVARCHAR(MAX), -- Comma-separated list of languages
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
AS
BEGIN
        DECLARE @AddressID int;
        -- Check if the address exists
        IF NOT EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName
        )
        BEGIN
            -- Call AddAddress to insert the new address
            EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;
        END;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;

        -- Insert new translator
        DECLARE @TranslatorID INT;
        INSERT INTO Translators (FirstName, LastName, AddressID, Phone, HireDate, Agreement)
        VALUES (@FirstName, @LastName, @AddressID, @Phone, @HireDate, @Agreement);

        -- Get the new TranslatorID
        SELECT @TranslatorID = TranslatorID FROM Translators
        WHERE FirstName = @FirstName
        AND LastName = @LastName
        AND AddressID = @AddressID
        AND Phone = @Phone
        AND HireDate = @HireDate;

        -- Split the languages and insert into TranslatorsLanguages
        DECLARE @LanguagesTable TABLE (LanguageName NVARCHAR(127));
        INSERT INTO @LanguagesTable (LanguageName)
        SELECT DISTINCT TRIM(value) AS LanguageName
        FROM STRING_SPLIT(@Languages, ',');

    DECLARE @RowCount INT = (SELECT COUNT(*) FROM @LanguagesTable);

    WHILE @RowCount > 0
        BEGIN
            DECLARE @LanguageName varchar(max);
            SELECT @LanguageName=LanguageName
            FROM @LanguagesTable
            ORDER BY LanguageName DESC OFFSET @RowCount - 1 ROWS FETCH NEXT 1 ROWS ONLY;

            EXEC AddTranslatorsLanguage @TranslatorID, @LanguageName

            SET @RowCount -= 1;
        END
END;
GO
CREATE PROCEDURE AddToCart
    @StudentID INT,
    @WebinarID INT = NULL,
    @ClassID INT = NULL,
    @CourseID INT = NULL,
    @SyllabusID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
        DECLARE @Price MONEY = 0;
        DECLARE @Tax DECIMAL(5, 2) = 0.32;

        -- Calculate final price based on provided IDs
        IF @WebinarID IS NOT NULL
        BEGIN
            SELECT @Price += Price
            FROM Webinars
            WHERE WebinarID = @WebinarID;
        END

        IF @ClassID IS NOT NULL
        BEGIN
            SELECT @Price += ClassPrice
            FROM Classes
            WHERE ClassID = @ClassID;
        END

        IF @CourseID IS NOT NULL
        BEGIN
            SELECT @Price += CoursePrice
            FROM Courses
            WHERE CourseID = @CourseID;
        END

        IF @SyllabusID IS NOT NULL
        BEGIN
            SELECT @Price += StudiesEntryFee
            FROM Syllabuses
            WHERE SyllabusID = @SyllabusID;
        END

        -- Validate that price is greater than 0, if it is, notthing was selected
        IF (@Price <= 0)
        BEGIN
            RAISERROR('Price must be greater than 0.', 16, 1);
        END

        -- Insert into Orders and capture OrderID
        DECLARE @OrderTable TABLE (OrderID INT);
        INSERT INTO Orders (StudentID, OrderDate, Status)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, GETUTCDATE(), 'incart');

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Calculate the final amount (price + tax)
        DECLARE @FinalAmount MONEY;
        SET @FinalAmount = @Price + (@Price * @Tax);

        -- Insert into OrderDetails and capture OrderDetailsID
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @FinalAmount, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        -- Insert into respective payment tables
        IF @WebinarID IS NOT NULL
        BEGIN
            INSERT INTO WebinarPayments (WebinarID, OrderDetailsID)
            VALUES (@WebinarID, @OrderDetailsID);
        END

        IF @ClassID IS NOT NULL
        BEGIN
            INSERT INTO ClassesPayments (ClassID, OrderDetailsID)
            VALUES (@ClassID, @OrderDetailsID);
        END

        IF @CourseID IS NOT NULL
        BEGIN
            INSERT INTO CoursePayments (CourseID, OrderDetailsID)
            VALUES (@CourseID, @OrderDetailsID);
        END

        IF @SyllabusID IS NOT NULL
        BEGIN
            INSERT INTO CollegeFees (OrderDetailsID, SyllabusID)
            VALUES (@OrderDetailsID, @SyllabusID);
        END
END;
GO;
CREATE PROCEDURE AddSyllabus
    @Description NVARCHAR(500) = NULL,
    @StudiesEntryFee DECIMAL(19,4),
    @EmployeeID INT,
    @PriceChange DECIMAL(10,4),
    @Edition NVARCHAR(100),
    @StartDate DATE,
    @EndDate DATE,
    @PlaceLimit INT
AS
BEGIN
    -- Check if the employee exists
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        RAISERROR ('Invalid EmployeeID', 16, 1);
    END;

    -- Insert into Syllabuses
    INSERT INTO Syllabuses (Description, StudiesEntryFee, EmployeeID, PriceChange, Edition, StartDate, EndDate, PlaceLimit)
    VALUES (@Description, @StudiesEntryFee, @EmployeeID, @PriceChange, @Edition, @StartDate, @EndDate, @PlaceLimit);
END
GO
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
CREATE PROCEDURE AddOrderPayment
    @OrderID INT
AS
    BEGIN
        SET NOCOUNT ON;
        -- Check if the order exists and is in the "incart" status
        IF NOT EXISTS (
            SELECT 1
            FROM Orders
            WHERE OrderID = @OrderID AND Status = 'incart'
        )
        BEGIN
            RAISERROR('Order does not exist or is not in the "incart" status.', 16, 1);
        END

        DECLARE @CurrentTime DATETIME;
        SELECT @CurrentTime = GETUTCDATE(); -- AT TIME ZONE CURRENT_TIMEZONE();

        -- Update the order status to "paid"
        UPDATE Orders
        SET Status = 'paid'
        WHERE OrderID = @OrderID;
        UPDATE Orders
        SET OrderDate = @CurrentTime
        WHERE OrderID = @OrderID;
    END;
GO;
CREATE PROCEDURE AddCollegePayment(
    @SyllabusID INT,
    @StudentID INT
)
AS
BEGIN
    SET NOCOUNT ON;
        -- Check Webinar existence
        IF NOT EXISTS (SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            RAISERROR('Webinar of ID %d does not exist', 16, 1, @SyllabusID);
        END;

        -- Check Student existence
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student of ID %d does not exist', 16, 1, @StudentID);
        END;

        -- Retrieve the Webinar Price
        DECLARE @Price MONEY;
        DECLARE @Tax DECIMAL(5, 2) = 0.32; -- Example tax rate

        SELECT @Price = StudiesEntryFee
        FROM Syllabuses
        WHERE SyllabusID = @SyllabusID;

        -- Validate Webinar Price
        IF @Price IS NULL OR @Price <= 0
        BEGIN
            RAISERROR('Webinar of ID %d has an invalid price', 16, 1, @SyllabusID);
        END;

        -- Declare table variables for capturing inserted IDs
        DECLARE @OrderTable TABLE (OrderID INT);
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);

        -- Insert a new Order and capture the OrderID
        INSERT INTO Orders (StudentID, Status, OrderDate)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, 'paid', GETUTCDATE());

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Insert Order Details and capture the OrderDetailsID
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @Price, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        -- Insert into WebinarPayments
        INSERT INTO CollegeFees (SyllabusID, OrderDetailsID)
        VALUES (@SyllabusID, @OrderDetailsID);

END;
GO
CREATE PROCEDURE EditInternshipAttendance
(
    @StudentID INT,
    @InternshipID INT,
    @InternshipDay INT,
    @Attendance BIT
)
    AS
    BEGIN
        BEGIN TRANSACTION;
        -- Check if syllabus exists
        IF NOT EXISTS(SELECT 1 FROM Internships WHERE InternshipID = @InternshipID)
        BEGIN
            RAISERROR ('Internship of ID %d does not exist', 16, 1, @InternshipID);
        END
            -- Check if student exists
        IF NOT EXISTS (
        SELECT 1
        FROM InternshipsAttendances
        WHERE InternshipID = @InternshipID AND StudentID = @StudentID
    )
    BEGIN
        RAISERROR ('This attendance does not exist, use AddInternshipAttendance to create it',16,1)
    END
    ELSE
    BEGIN
        -- Update if attendance already exists, that is if that's an excused absence or there has been an error
        UPDATE InternshipsAttendances
        SET Attended = @Attendance
        WHERE InternshipID = @InternshipID AND StudentID = @StudentID AND InternshipDay = @InternshipDay;
    END;
    END
    GO;
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
CREATE PROCEDURE EditRoleDescription
(
    @Role VARCHAR(64) = NULL,
    @NewDescription VARCHAR(MAX)
)
AS
BEGIN
    BEGIN
        -- Is Role provided
        IF @Role IS NULL
        BEGIN
            THROW 50001, 'Role name must be provided.', 1;
        END;

        UPDATE EmployeesRoles
        SET Description = @NewDescription
        WHERE LOWER(Role) = LOWER(@Role);

        -- Commit the transaction if successful
        COMMIT TRANSACTION;
    END;
END;
GO;

CREATE PROCEDURE AddStudentToClass(
    @StudentID INT,
    @ClassID INT
)
AS
    BEGIN
        -- Check if the student exists
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        -- Check if the course exists
        IF NOT EXISTS(SELECT 1 FROM Classes WHERE ClassID = @ClassID)
        BEGIN
            RAISERROR ('Class of ID %d does not exist', 16, 1, @ClassID);
        END
        -- To be discussed, as it could be an exception procedure, the trigger handles adding student after payment
        -- IF NOT EXISTS(
        --     SELECT 1
        --     FROM Orders o
        --     INNER JOIN Students s ON o.StudentID = s.StudentID
        --     INNER JOIN OrderDetails od ON od.OrderID = o.OrderID
        --     INNER JOIN ClassesPayments cp ON cp.OrderDetailsID = od.OrderDetailsID
        --     WHERE cp.ClassID = @ClassID AND o.StudentID = @StudentID
        -- )
        -- BEGIN
        --     RAISERROR ('Student has not paid for the course', 16, 1);
        -- END;
        INSERT INTO StudentsToClass (StudentID, ClassID) VALUES (@StudentID,@ClassID);
    END
GO;

CREATE PROCEDURE AddClassroom
    (
        @BuildingID INT,
        @ClassroomLimit INT
    )
AS
    BEGIN
            IF NOT EXISTS(SELECT 1 FROM Buildings WHERE BuildingID = @BuildingID)
                BEGIN
                    RAISERROR ('Building of ID %d does not exits',16,1,@BuildingID);
                END
            INSERT INTO Classrooms (BuildingID, PlacesLimit) VALUES (@BuildingID,@ClassroomLimit);
    END
GO;
CREATE PROCEDURE AddSubject
(
    @SubjectName VARCHAR(64),
    @SyllabusID INT,
    @Description VARCHAR(MAX) = NULL
)
AS
BEGIN
    BEGIN TRANSACTION;
    IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
    INSERT INTO Subjects (SubjectName, SyllabusID, Description) VALUES (@SubjectName,@SyllabusID,@Description);
    COMMIT TRANSACTION;
END;
GO;
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
CREATE PROCEDURE AddCourseType(
    @CourseTypeID INT,
    @CourseName VARCHAR(32)
)
AS
   BEGIN
       INSERT INTO CourseTypes (CourseTypeID, CourseTypeName) VALUES (@CourseTypeID,@CourseName);
   END
GO;

CREATE PROCEDURE AddStudentToMajor(
    @StudentID INT,
    @SyllabusID INT
)
AS
    BEGIN
        -- Check if the student exists
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        -- Check if the course exists
        IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
        -- To be discussed, as it could be an exception procedure, the trigger handles adding student after payment
        -- IF NOT EXISTS(
        --     SELECT 1
        --     FROM Orders o
        --     INNER JOIN Students s ON o.StudentID = s.StudentID
        --     INNER JOIN OrderDetails od ON od.OrderID = o.OrderID
        --     INNER JOIN CollegeFees cf ON cf.OrderDetailsID = od.OrderDetailsID
        --     WHERE cf.SyllabusID = @SyllabusID AND o.StudentID = @StudentID
        -- )
        -- BEGIN
        --     RAISERROR ('Student has not paid for the course', 16, 1);
        -- END;
        INSERT INTO CollegeClass (StudentID, SyllabusID) VALUES (@StudentID,@SyllabusID);
    END
GO;

CREATE PROCEDURE DeleteStudentFromCollegeClass
    @student_id INT,
    @class_id INT
AS
BEGIN
    IF @student_id NOT IN (SELECT StudentID FROM Students)
        THROW 50000, 'Student not found', 11;

    DELETE CollegeClass WHERE StudentID = @student_id AND CollegeClassID = @class_id;
    DELETE ClassesAttendances WHERE StudentID  = @student_id AND ClassID = @class_id;
    DELETE InternshipsAttendances WHERE StudentID = @student_id;
END
GO;
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

CREATE PROCEDURE AddWebinarPayment(
    @WebinarID INT,
    @StudentID INT
)
AS
BEGIN
    SET NOCOUNT ON;
        -- Check Webinar existence
        IF NOT EXISTS (SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        BEGIN
            RAISERROR('Webinar of ID %d does not exist', 16, 1, @WebinarID);
        END;

        -- Check Student existence
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student of ID %d does not exist', 16, 1, @StudentID);
        END;

        -- Retrieve the Webinar Price
        DECLARE @Price MONEY;
        DECLARE @Tax DECIMAL(5, 2) = 0.32; -- Example tax rate

        SELECT @Price = Price
        FROM Webinars
        WHERE WebinarID = @WebinarID;

        -- Validate Webinar Price
        IF @Price IS NULL OR @Price <= 0
        BEGIN
            RAISERROR('Webinar of ID %d has an invalid price', 16, 1, @WebinarID);
        END;

        -- Declare table variables for capturing inserted IDs
        DECLARE @OrderTable TABLE (OrderID INT);
        DECLARE @OrderDetailsTable TABLE (OrderDetailsID INT);

        -- Insert a new Order and capture the OrderID
        INSERT INTO Orders (StudentID, Status, OrderDate)
        OUTPUT INSERTED.OrderID INTO @OrderTable
        VALUES (@StudentID, 'paid',GETUTCDATE());

        -- Retrieve the OrderID
        DECLARE @OrderID INT;
        SELECT @OrderID = OrderID FROM @OrderTable;

        -- Insert Order Details and capture the OrderDetailsID
        INSERT INTO OrderDetails (OrderID, Amount, Tax)
        OUTPUT INSERTED.OrderDetailsID INTO @OrderDetailsTable
        VALUES (@OrderID, @Price, @Tax);

        -- Retrieve the OrderDetailsID
        DECLARE @OrderDetailsID INT;
        SELECT @OrderDetailsID = OrderDetailsID FROM @OrderDetailsTable;

        -- Insert into WebinarPayments
        INSERT INTO WebinarPayments (WebinarID, OrderDetailsID)
        VALUES (@WebinarID, @OrderDetailsID);
END;
GO
CREATE PROCEDURE AddFinalExamGrade(
    @StudentID INT,
    @SyllabusID INT,
    @GradeValue DECIMAL(2,1)
)
AS
    BEGIN
        -- Check if the syllabus exists
        IF NOT EXISTS(SELECT 1 FROM Syllabuses WHERE SyllabusID = @SyllabusID)
        BEGIN
            RAISERROR ('Syllabus of ID %d does not exist', 16, 1, @SyllabusID);
        END
        -- Check if grade exists
        IF NOT EXISTS(SELECT 1 FROM Grades WHERE GradeValue = @GradeValue)
            BEGIN
                DECLARE @GradeValueString VARCHAR(MAX) = @GradeValue;
                RAISERROR ('Grade of value %s does not exist', 16, 1, @GradeValueString);
            END
        DECLARE @GradeID INT;
        SELECT @GradeID = GradeID FROM Grades WHERE GradeValue = @GradeValue;
        INSERT INTO FinalExamGrades (GradeID, StudentID, SyllabusID) VALUES (@GradeID,@StudentID,@SyllabusID);
    END
GO;
CREATE PROCEDURE AddStudent
(
    @FirstName VARCHAR(64),
    @LastName VARCHAR(64),
    @Phone VARCHAR(16),
    @Agreement BIT,
    @StreetName VARCHAR(32),
    @Region VARCHAR(32),
    @CityName VARCHAR(32),
    @CountryName VARCHAR(32)
)
AS
BEGIN
    BEGIN
        DECLARE @AddressID INT;

        -- Check if the agreement is accepted
        IF @Agreement != 1
        BEGIN
            RAISERROR ('The agreement must be accepted',16,1);
        END;

        -- Check if the employee already exists
        IF EXISTS (
            SELECT 1
            FROM Students
            WHERE FirstName = @FirstName
              AND LastName = @LastName
              AND Phone = @Phone
        )
        BEGIN
            RAISERROR ('This student already exists',16,1);
        END;

        -- Check if the address exists
        IF NOT EXISTS (
            SELECT 1
            FROM Addresses a
            INNER JOIN City c ON a.CityID = c.CityID
            WHERE a.StreetName = @StreetName
              AND a.Region = @Region
              AND c.CityName = @CityName
              AND c.CountryName = @CountryName
        )
        BEGIN
            -- Call AddAddress to insert the new address
            EXEC AddAddress @StreetName, @Region, @CityName, @CountryName;
        END;
        SELECT @AddressID = a.AddressID
        FROM Addresses a
        INNER JOIN City c ON a.CityID = c.CityID
        WHERE a.StreetName = @StreetName
          AND a.Region = @Region
          AND c.CityName = @CityName
          AND c.CountryName = @CountryName;

        -- Insert the employee into the database
        INSERT INTO Students (FirstName, LastName, AddressID, Phone, Agreement)
        VALUES (@FirstName, @LastName, @AddressID, @Phone, @Agreement);
    END;
END;
GO;
CREATE PROCEDURE AddGrade(
    @GradeID INT,
    @GradeValue DECIMAL(2,1),
    @GradeName VARCHAR(64)
)
AS
    BEGIN
        INSERT INTO Grades (GradeID, GradeValue, GradeName) VALUES (@GradeID,@GradeValue,@GradeName);
    END
GO
CREATE PROCEDURE AddClassType
(
    @ClassTypeID INT,
    @ClassTypeName VARCHAR(64)
)
AS
    BEGIN
        INSERT INTO ClassTypes (ClassTypeID,ClassTypeName) VALUES (@ClassTypeID,@ClassTypeName);
    END
GO
CREATE PROCEDURE AddStudentToCourse(
    @StudentID INT,
    @CourseID INT
)
AS
    BEGIN
        -- Check if the student exists
        IF NOT EXISTS(SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR ('Student of ID %d does not exist', 16, 1, @StudentID);
        END
        -- Check if the course exists
        IF NOT EXISTS(SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            RAISERROR ('Course of ID %d does not exist', 16, 1, @CourseID);
        END
        -- To be discussed, as it could be an exception procedure, the trigger handles adding student after payment
        -- IF NOT EXISTS(
        --     SELECT 1
        --     FROM Orders o
        --     INNER JOIN Students s ON o.StudentID = s.StudentID
        --     INNER JOIN OrderDetails od ON od.OrderID = o.OrderID
        --     INNER JOIN CoursePayments cp ON cp.OrderDetailsID = od.OrderDetailsID
        --     WHERE cp.CourseID = @CourseID AND o.StudentID = @StudentID
        -- )
        -- BEGIN
        --     RAISERROR ('Student has not paid for the course', 16, 1);
        -- END;
        INSERT INTO StudentsCourses (StudentID, CourseID) VALUES (@StudentID,@CourseID);
    END
GO;
