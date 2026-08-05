USE InventoryManagementDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[master].[AuditLog]') AND type in (N'U'))
BEGIN
    CREATE TABLE master.AuditLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        UserID INT NULL, -- Can be NULL for system actions or failed logins
        Username NVARCHAR(50) NULL,
        Action NVARCHAR(100) NOT NULL, -- e.g., 'User Login', 'Create Product', 'Adjust Stock'
        Details NVARCHAR(MAX) NULL, -- JSON or text details of the change
        IPAddress NVARCHAR(50) NULL,
        LogDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_AuditLog_User FOREIGN KEY (UserID) REFERENCES master.[User](UserID)
    );
END
GO
