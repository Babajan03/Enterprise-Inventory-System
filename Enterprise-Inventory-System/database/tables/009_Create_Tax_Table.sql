/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Tax
Script Name  : 009_Create_Tax_Table.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Creates the Tax master table.
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Tax', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.Tax;
END
GO

CREATE TABLE master.Tax
(
    TaxID INT IDENTITY(1,1) NOT NULL,

    TaxCode VARCHAR(20) NOT NULL,

    TaxName NVARCHAR(100) NOT NULL,

    TaxPercentage DECIMAL(5,2) NOT NULL,

    Description NVARCHAR(250) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Tax_IsActive DEFAULT (1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Tax_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_Tax_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    RowVersion ROWVERSION,

    CONSTRAINT PK_Tax
        PRIMARY KEY CLUSTERED (TaxID),

    CONSTRAINT UQ_Tax_Code
        UNIQUE (TaxCode),

    CONSTRAINT UQ_Tax_Name
        UNIQUE (TaxName),

    CONSTRAINT CK_Tax_Percentage
        CHECK (TaxPercentage >= 0 AND TaxPercentage <= 100)
);
GO

PRINT 'master.Tax created successfully.';
GO