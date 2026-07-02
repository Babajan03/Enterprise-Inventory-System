/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Supplier Management
Object Name  : ProductSupplier
Script Name  : 023_Create_ProductSupplier_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.ProductSupplier','U') IS NOT NULL
    DROP TABLE master.ProductSupplier;
GO

CREATE TABLE master.ProductSupplier
(
    ProductSupplierID INT IDENTITY(1,1) NOT NULL,

    ProductID INT NOT NULL,

    SupplierID INT NOT NULL,

    SupplierProductCode VARCHAR(50) NULL,

    PurchasePrice DECIMAL(18,2) NOT NULL,

    LeadTimeDays INT NOT NULL
        CONSTRAINT DF_ProductSupplier_LeadTime DEFAULT(7),

    IsPreferredSupplier BIT NOT NULL
        CONSTRAINT DF_ProductSupplier_Preferred DEFAULT(0),

    IsActive BIT NOT NULL
        CONSTRAINT DF_ProductSupplier_IsActive DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_ProductSupplier_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_ProductSupplier_CreatedBy DEFAULT(SUSER_SNAME()),

    RowVersion ROWVERSION,

    CONSTRAINT PK_ProductSupplier
        PRIMARY KEY(ProductSupplierID),

    CONSTRAINT FK_ProductSupplier_Product
        FOREIGN KEY(ProductID)
        REFERENCES master.Product(ProductID),

    CONSTRAINT FK_ProductSupplier_Supplier
        FOREIGN KEY(SupplierID)
        REFERENCES master.Supplier(SupplierID),

    CONSTRAINT UQ_ProductSupplier
        UNIQUE(ProductID, SupplierID),

    CONSTRAINT CK_ProductSupplier_PurchasePrice
        CHECK(PurchasePrice >= 0),

    CONSTRAINT CK_ProductSupplier_LeadTime
        CHECK(LeadTimeDays >= 0)
);
GO

PRINT 'ProductSupplier table created successfully.';
GO


SELECT *
FROM master.ProductSupplier;