DECLARE @drop_procedures NVARCHAR(MAX) = ''
SELECT @drop_procedures += 'DROP PROCEDURE [sys].' + QUOTENAME(name) + '; ' FROM sys.Objects WHERE type = 'P';
EXEC Sp_executesql @drop_procedures;