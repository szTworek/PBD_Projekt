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
