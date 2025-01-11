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