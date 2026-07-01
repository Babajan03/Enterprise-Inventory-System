/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Unit
Script Name  : 007_Create_Unit_Table.sql
Author       : Shaik Babajan
Created Date : 2026-07-02
Version      : 1.0

Description:
Creates the Unit master table.

Modification History

Version    Date          Author            Description
-------    ----------    ----------------  ------------------------------
1.0        2026-07-02    Shaik Babajan     Initial creation
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Unit', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.Unit;
END
GO

CREATE TABLE master.Unit
(
    UnitID INT IDENTITY(1,1) NOT NULL,

    UnitCode VARCHAR(20) NOT NULL,

    UnitName NVARCHAR(50) NOT NULL,

    UnitSymbol NVARCHAR(10) NOT NULL,

    Description NVARCHAR(250) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Unit_IsActive
        DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Unit_CreatedDate
        DEFAULT(SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_Unit_CreatedBy
        DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    RowVersion ROWVERSION,

    CONSTRAINT PK_Unit
        PRIMARY KEY CLUSTERED (UnitID),

    CONSTRAINT UQ_Unit_Code
        UNIQUE (UnitCode),

    CONSTRAINT UQ_Unit_Name
        UNIQUE (UnitName)
);
GO

PRINT 'master.Unit created successfully.';
GO