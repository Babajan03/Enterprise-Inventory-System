
USE InventoryManagementDB;
GO
CREATE PROCEDURE master.SP_Add_User
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255),
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @Role NVARCHAR(30)
AS
BEGIN
    INSERT INTO master.[User] (Username, PasswordHash, FullName, Email, Role)
    VALUES (@Username, @PasswordHash, @FullName, @Email, @Role);
END