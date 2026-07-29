USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Admin_Reset_Password
    @UserID INT,
    @PasswordHash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE master.[User]
    SET PasswordHash = @PasswordHash
    WHERE UserID = @UserID;
END;
GO
