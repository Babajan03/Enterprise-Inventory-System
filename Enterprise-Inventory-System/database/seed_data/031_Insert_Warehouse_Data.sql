USE InventoryManagementDB;
GO

/*
    Script Name : 031_Insert_Warehouse_Data.sql
    Purpose     : Insert initial warehouse master data
    Module      : Inventory Management
*/

INSERT INTO inventory.Warehouse
(
    WarehouseCode,
    WarehouseName,
    Location,
    IsActive,
    CreatedDate
)
VALUES
(
    'WH001',
    'Main Warehouse',
    'Hyderabad',
    1,
    GETDATE()
),
(
    'WH002',
    'Secondary Warehouse',
    'Bangalore',
    1,
    GETDATE()
),
(
    'WH003',
    'Transit Warehouse',
    'Chennai',
    1,
    GETDATE()
);
GO