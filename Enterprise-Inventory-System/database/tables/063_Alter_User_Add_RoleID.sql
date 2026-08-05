USE InventoryManagementDB;
GO

-- Add RoleID column to User table and FK to Role
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE Name = N'RoleID' AND Object_ID = Object_ID(N'master.[User]')
)
BEGIN
    ALTER TABLE master.[User]
    ADD RoleID INT NOT NULL CONSTRAINT DF_User_RoleID DEFAULT 2; -- default Manager

    ALTER TABLE master.[User]
    ADD CONSTRAINT FK_User_Role FOREIGN KEY (RoleID) REFERENCES master.Role(RoleID);
END
GO

-- Optional: keep existing Role column for backward compatibility but mark as deprecated
-- You may drop it later after migration
