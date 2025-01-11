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