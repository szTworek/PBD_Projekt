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