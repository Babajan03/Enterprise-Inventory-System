/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Category
Script Name  : 003_Create_Category_Table.sql
Author       : Shaik Babajan
Created Date : 2026-06-30
Version      : 1.0

Description:
Creates the Category master table.

Modification History

Version    Date          Author            Description
-------    ----------    ----------------  ------------------------------
1.0        2026-06-30    Shaik Babajan     Initial creation
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Category', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.Category;
END
GO

CREATE TABLE master.Category
(
    CategoryID INT IDENTITY(1,1) NOT NULL,

    CategoryCode VARCHAR(20) NOT NULL,

    CategoryName VARCHAR(100) NOT NULL,

    Description VARCHAR(500) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Category_IsActive
        DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Category_CreatedDate
        DEFAULT(SYSDATETIME()),

    CreatedBy VARCHAR(100) NOT NULL
        CONSTRAINT DF_Category_CreatedBy
        DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy VARCHAR(100) NULL,

    CONSTRAINT PK_Category
        PRIMARY KEY CLUSTERED (CategoryID),

    CONSTRAINT UQ_Category_Code
        UNIQUE(CategoryCode),

    CONSTRAINT UQ_Category_Name
        UNIQUE(CategoryName)
);
GO

PRINT 'Table master.Category created successfully.';
GO