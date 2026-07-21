/*
    Script Name : 031_Create_Warehouse_Table.sql
    Project     : Enterprise Inventory Management System
    Purpose     : Create Warehouse Master Table
*/



USE InventoryManagementDB;
GO


CREATE TABLE inventory.Warehouse
(
    WarehouseId INT IDENTITY(1,1)
        CONSTRAINT PK_Warehouse PRIMARY KEY,


    WarehouseCode VARCHAR(20) NOT NULL
        CONSTRAINT UQ_Warehouse_WarehouseCode UNIQUE,


    WarehouseName VARCHAR(100) NOT NULL,


    AddressLine1 VARCHAR(150) NULL,

    AddressLine2 VARCHAR(150) NULL,

    City VARCHAR(50) NULL,

    State VARCHAR(50) NULL,

    Country VARCHAR(50) NULL,

    PostalCode VARCHAR(20) NULL,


    ContactPerson VARCHAR(100) NULL,

    ContactNumber VARCHAR(20) NULL,


    IsActive BIT NOT NULL
        CONSTRAINT DF_Warehouse_IsActive DEFAULT 1,


    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Warehouse_CreatedDate DEFAULT SYSDATETIME(),


    CreatedBy VARCHAR(50) NOT NULL
        CONSTRAINT DF_Warehouse_CreatedBy DEFAULT 'SYSTEM',


    ModifiedDate DATETIME2 NULL,

    ModifiedBy VARCHAR(50) NULL
);
GO


USE InventoryManagementDB;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Warehouse';

EXEC sp_help 'inventory.Warehouse';