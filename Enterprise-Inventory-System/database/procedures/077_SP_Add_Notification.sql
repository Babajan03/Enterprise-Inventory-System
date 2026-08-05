USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Add_Notification
    @UserID INT = NULL,
    @Message NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO master.Notification (UserID, Message)
    VALUES (@UserID, @Message);
END;
GO
