USE InventoryManagementDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[master].[Role]') AND type in (N'U'))
BEGIN
    CREATE TABLE master.Role (
        RoleID INT IDENTITY(1,1) PRIMARY KEY,
        RoleName NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(255) NULL
    );
    INSERT INTO master.Role (RoleName, Description) VALUES
        (N'Admin', N'Full access to all modules'),
        (N'Manager', N'Can manage inventory, reports, and users'),
        (N'Cashier', N'Can create sales orders only');
END
GO
