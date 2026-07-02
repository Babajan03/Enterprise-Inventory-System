/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Supplier Management
Object Name  : Supplier
Script Name  : 021_Create_Supplier_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Supplier','U') IS NOT NULL
DROP TABLE master.Supplier;
GO

CREATE TABLE master.Supplier
(

SupplierID INT IDENTITY(1,1),

SupplierCode VARCHAR(20) NOT NULL,

SupplierName NVARCHAR(200) NOT NULL,

ContactPerson NVARCHAR(150) NULL,

Email NVARCHAR(150) NULL,

Phone VARCHAR(20) NULL,

GSTNumber VARCHAR(20) NULL,

AddressLine1 NVARCHAR(250) NULL,

City NVARCHAR(100) NULL,

StateName NVARCHAR(100) NULL,

CountryName NVARCHAR(100) NULL,

PostalCode VARCHAR(20) NULL,

IsActive BIT NOT NULL
CONSTRAINT DF_Supplier_IsActive DEFAULT(1),

CreatedDate DATETIME2 NOT NULL
CONSTRAINT DF_Supplier_CreatedDate DEFAULT(SYSDATETIME()),

CreatedBy NVARCHAR(100) NOT NULL
CONSTRAINT DF_Supplier_CreatedBy DEFAULT(SUSER_SNAME()),

ModifiedDate DATETIME2 NULL,

ModifiedBy NVARCHAR(100) NULL,

RowVersion ROWVERSION,

CONSTRAINT PK_Supplier
PRIMARY KEY(SupplierID),

CONSTRAINT UQ_Supplier_Code
UNIQUE(SupplierCode),

CONSTRAINT UQ_Supplier_Name
UNIQUE(SupplierName)

);

GO

PRINT 'Supplier table created successfully.';
GO


SELECT *
FROM master.Supplier;