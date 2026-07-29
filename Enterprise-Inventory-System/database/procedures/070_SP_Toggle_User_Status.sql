USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Toggle_User_Status
    @UserID INT,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE master.[User]
    SET IsActive = @IsActive
    WHERE UserID = @UserID;
END;
GO
