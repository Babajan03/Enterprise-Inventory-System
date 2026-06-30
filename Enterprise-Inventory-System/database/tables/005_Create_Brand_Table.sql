/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Brand
Script Name  : 004_Create_Brand_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Brand','U') IS NOT NULL
BEGIN
    DROP TABLE master.Brand;
END
GO

CREATE TABLE master.Brand
(
    BrandID INT IDENTITY(1,1) NOT NULL,

    BrandCode VARCHAR(20) NOT NULL,

    BrandName VARCHAR(100) NOT NULL,

    Description VARCHAR(500) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Brand_IsActive DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Brand_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy VARCHAR(100) NOT NULL
        CONSTRAINT DF_Brand_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy VARCHAR(100) NULL,

    RowVersion ROWVERSION,

    CONSTRAINT PK_Brand
        PRIMARY KEY CLUSTERED (BrandID),

    CONSTRAINT UQ_Brand_Code
        UNIQUE(BrandCode),

    CONSTRAINT UQ_Brand_Name
        UNIQUE(BrandName)
);
GO