USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Mark_Notification_Read
    @NotificationID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE master.Notification
    SET IsRead = 1
    WHERE NotificationID = @NotificationID AND (UserID = @UserID OR UserID IS NULL);
END;
GO
