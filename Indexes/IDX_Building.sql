CREATE INDEX IDX_Buildings_BuildingID ON Buildings (BuildingID);
CREATE INDEX IDX_Buildings_AddressID ON Buildings (AddressID);
CREATE INDEX IDX_Classrooms_ClassroomID ON Classrooms (ClassroomID);
CREATE INDEX IDX_Classrooms_BuildingID_ClassroomID ON Classrooms (BuildingID, ClassroomID);