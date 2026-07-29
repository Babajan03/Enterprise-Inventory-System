USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Update_User
    @UserID INT,
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @Role NVARCHAR(30),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE master.[User]
    SET FullName = @FullName,
        Email = @Email,
        Role = @Role,
        IsActive = @IsActive
    WHERE UserID = @UserID;
END;
GO
