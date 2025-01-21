SELECT B.BuildingID, B.AddressID, C.ClassroomID, C.PlacesLimit
FROM Buildings B
         JOIN Classrooms C ON B.BuildingID = C.BuildingID
