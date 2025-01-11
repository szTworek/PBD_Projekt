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