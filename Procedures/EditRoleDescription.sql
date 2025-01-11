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
