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
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    PostalCode,
    ContactPerson,
    ContactNumber,
    IsActive,
    CreatedDate,
    CreatedBy
)
VALUES
(
    'WH001',
    'Main Warehouse',
    'Hitech City Road',
    'Madhapur',
    'Hyderabad',
    'Telangana',
    'India',
    '500081',
    'Raj Kumar',
    '9000000001',
    1,
    SYSDATETIME(),
    'SYSTEM'
),
(
    'WH002',
    'Bangalore Distribution Center',
    'Electronic City Phase 1',
    NULL,
    'Bangalore',
    'Karnataka',
    'India',
    '560100',
    'Arun Kumar',
    '9000000002',
    1,
    SYSDATETIME(),
    'SYSTEM'
),
(
    'WH003',
    'Chennai Transit Warehouse',
    'OMR Road',
    NULL,
    'Chennai',
    'Tamil Nadu',
    'India',
    '600096',
    'Vijay Kumar',
    '9000000003',
    1,
    SYSDATETIME(),
    'SYSTEM'
);
GO



SELECT COUNT(*) AS WarehouseCount
FROM inventory.Warehouse;

SELECT *
FROM inventory.Warehouse;