/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Inventory Management
Object Name  : Inventory
Script Name  : 030_Create_Inventory_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('inventory.Inventory','U') IS NOT NULL
DROP TABLE inventory.Inventory;
GO

CREATE TABLE inventory.Inventory
(
    InventoryID INT IDENTITY(1,1) NOT NULL,

    ProductID INT NOT NULL,

    WarehouseID INT NOT NULL,

    QuantityOnHand DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Inventory_QOH DEFAULT(0),

    ReservedQuantity DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Inventory_Reserved DEFAULT(0),

    ReorderQuantity DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Inventory_Reorder DEFAULT(0),

    LastStockUpdate DATETIME2 NOT NULL
        CONSTRAINT DF_Inventory_LastUpdate DEFAULT(SYSDATETIME()),

    RowVersion ROWVERSION,

    CONSTRAINT PK_Inventory
        PRIMARY KEY(InventoryID),

    CONSTRAINT FK_Inventory_Product
        FOREIGN KEY(ProductID)
        REFERENCES master.Product(ProductID),

    CONSTRAINT FK_Inventory_Warehouse
        FOREIGN KEY(WarehouseID)
        REFERENCES master.Warehouse(WarehouseID),

    CONSTRAINT UQ_Inventory_ProductWarehouse
        UNIQUE(ProductID, WarehouseID),

    CONSTRAINT CK_Inventory_QOH
        CHECK(QuantityOnHand >= 0),

    CONSTRAINT CK_Inventory_Reserved
        CHECK(ReservedQuantity >= 0),

    CONSTRAINT CK_Inventory_Reorder
        CHECK(ReorderQuantity >= 0)
);
GO

PRINT 'Inventory table created successfully.';
GO