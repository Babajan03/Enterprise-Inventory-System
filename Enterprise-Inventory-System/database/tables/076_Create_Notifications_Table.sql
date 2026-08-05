USE InventoryManagementDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[master].[Notification]') AND type in (N'U'))
BEGIN
    CREATE TABLE master.Notification (
        NotificationID INT IDENTITY(1,1) PRIMARY KEY,
        UserID INT NULL, -- NULL means broadcast to all users
        Message NVARCHAR(255) NOT NULL,
        IsRead BIT NOT NULL DEFAULT 0,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Notification_User FOREIGN KEY (UserID) REFERENCES master.[User](UserID)
    );
END
GO
