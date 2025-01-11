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