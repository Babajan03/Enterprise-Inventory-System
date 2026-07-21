USE InventoryManagementDB;
GO

/*
    Script Name : 033_Insert_Opening_Inventory.sql
    Purpose     : Insert initial stock available in warehouse
    Module      : Inventory Management
*/


INSERT INTO inventory.Inventory
(
    WarehouseId,
    ProductId,
    Quantity,
    ReorderLevel,
    CreatedBy
)
VALUES
(
    1,          -- Main Warehouse
    1,          -- Dell Inspiron 15 Gen 2
    50,         -- Opening Quantity
    10,         -- Reorder Level
    'SYSTEM'
);
GO


SELECT *
FROM inventory.Inventory;