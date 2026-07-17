/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Schema       : master
Object Name  : Product
Script Name  : 013_Create_Product_Table.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Creates the Product master table.

==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('master.Product', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.Product;
END
GO

CREATE TABLE master.Product
(
    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------

    ProductID INT IDENTITY(1,1) NOT NULL,

    --------------------------------------------------------------------------
    -- Business Information
    --------------------------------------------------------------------------

    ProductCode VARCHAR(30) NOT NULL,

    ProductName NVARCHAR(200) NOT NULL,

    ProductDescription NVARCHAR(500) NULL,

    SKU VARCHAR(50) NULL,

    Barcode VARCHAR(100) NULL,

    HSNCode VARCHAR(20) NULL,

    --------------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------------

    CategoryID INT NOT NULL,

    BrandID INT NOT NULL,

    UnitID INT NOT NULL,

    TaxID INT NOT NULL,

    CurrencyID INT NOT NULL,

    --------------------------------------------------------------------------
    -- Pricing
    --------------------------------------------------------------------------

    CostPrice DECIMAL(18,2) NOT NULL,

    SellingPrice DECIMAL(18,2) NOT NULL,

    --------------------------------------------------------------------------
    -- Inventory
    --------------------------------------------------------------------------

    MinimumStock INT NOT NULL
        CONSTRAINT DF_Product_MinimumStock DEFAULT(0),

    MaximumStock INT NOT NULL
        CONSTRAINT DF_Product_MaximumStock DEFAULT(1000),

    ReorderLevel INT NOT NULL
        CONSTRAINT DF_Product_ReorderLevel DEFAULT(10),

    --------------------------------------------------------------------------
    -- Status
    --------------------------------------------------------------------------

    IsActive BIT NOT NULL
        CONSTRAINT DF_Product_IsActive DEFAULT(1),

    --------------------------------------------------------------------------
    -- Audit
    --------------------------------------------------------------------------

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Product_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_Product_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    RowVersion ROWVERSION,

    --------------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------------

    CONSTRAINT PK_Product
        PRIMARY KEY CLUSTERED(ProductID),

    CONSTRAINT UQ_Product_ProductCode
        UNIQUE(ProductCode),

    CONSTRAINT UQ_Product_ProductName
        UNIQUE(ProductName),

    CONSTRAINT CK_Product_CostPrice
        CHECK(CostPrice >= 0),

    CONSTRAINT CK_Product_SellingPrice
        CHECK(SellingPrice >= 0),

    CONSTRAINT CK_Product_MinimumStock
        CHECK(MinimumStock >= 0),

    CONSTRAINT CK_Product_MaximumStock
        CHECK(MaximumStock >= MinimumStock),

    CONSTRAINT CK_Product_ReorderLevel
        CHECK(ReorderLevel >= 0),

    CONSTRAINT FK_Product_Category
        FOREIGN KEY(CategoryID)
        REFERENCES master.Category(CategoryID),

    CONSTRAINT FK_Product_Brand
        FOREIGN KEY(BrandID)
        REFERENCES master.Brand(BrandID),

    CONSTRAINT FK_Product_Unit
        FOREIGN KEY(UnitID)
        REFERENCES master.Unit(UnitID),

    CONSTRAINT FK_Product_Tax
        FOREIGN KEY(TaxID)
        REFERENCES master.Tax(TaxID),

    CONSTRAINT FK_Product_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES master.Currency(CurrencyID)
);
GO

PRINT 'master.Product table created successfully.';
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE INDEX IX_Product_CategoryID
ON master.Product(CategoryID);
GO

CREATE INDEX IX_Product_BrandID
ON master.Product(BrandID);
GO

CREATE INDEX IX_Product_UnitID
ON master.Product(UnitID);
GO

CREATE INDEX IX_Product_TaxID
ON master.Product(TaxID);
GO

CREATE INDEX IX_Product_CurrencyID
ON master.Product(CurrencyID);
GO

CREATE INDEX IX_Product_ProductName
ON master.Product(ProductName);
GO

PRINT 'Indexes created successfully.';
GO



EXEC sp_help 'master.Product';

SELECT *
FROM master.Product;