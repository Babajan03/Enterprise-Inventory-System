USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_Notifications
    @UserID INT,
    @UnreadOnly BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 50
        NotificationID,
        UserID,
        Message,
        IsRead,
        CreatedDate
    FROM master.Notification
    WHERE (UserID = @UserID OR UserID IS NULL)
      AND (@UnreadOnly = 0 OR IsRead = 0)
    ORDER BY CreatedDate DESC;
END;
GO
