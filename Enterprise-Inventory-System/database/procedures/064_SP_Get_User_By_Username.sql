
USE InventoryManagementDB;
GO
CREATE PROCEDURE master.SP_Get_User_By_Username
    @Username NVARCHAR(50)
AS
BEGIN
    SELECT UserID, Username, PasswordHash, FullName, Email, Role, IsActive
    FROM master.[User]
    WHERE Username = @Username;
END