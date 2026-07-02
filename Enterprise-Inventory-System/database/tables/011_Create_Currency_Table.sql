/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Currency
Script Name  : 011_Create_Currency_Table.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Creates the Currency master table.
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Currency', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.Currency;
END
GO

CREATE TABLE master.Currency
(
    CurrencyID INT IDENTITY(1,1) NOT NULL,

    CurrencyCode VARCHAR(10) NOT NULL,

    CurrencyName NVARCHAR(100) NOT NULL,

    CurrencySymbol NVARCHAR(10) NOT NULL,

    CountryName NVARCHAR(100) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Currency_IsActive DEFAULT (1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Currency_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_Currency_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    RowVersion ROWVERSION,

    CONSTRAINT PK_Currency
        PRIMARY KEY CLUSTERED (CurrencyID),

    CONSTRAINT UQ_Currency_Code
        UNIQUE (CurrencyCode),

    CONSTRAINT UQ_Currency_Name
        UNIQUE (CurrencyName)
);
GO

PRINT 'master.Currency created successfully.';
GO