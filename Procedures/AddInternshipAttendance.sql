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