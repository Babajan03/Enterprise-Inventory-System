USE InventoryManagementDB;
GO


INSERT INTO purchase.Supplier
(
    SupplierCode,
    SupplierName,
    ContactPerson,
    Email,
    PhoneNumber,
    City,
    State,
    Country,
    CreatedBy
)
VALUES
(
    'SUP001',
    'Dell Technologies Supplier',
    'Ramesh Kumar',
    'sales@dellsupplier.com',
    '9000000021',
    'Hyderabad',
    'Telangana',
    'India',
    'SYSTEM'
),
(
    'SUP002',
    'HP Distribution Partner',
    'Suresh Kumar',
    'sales@hpsupplier.com',
    '9000000022',
    'Bangalore',
    'Karnataka',
    'India',
    'SYSTEM'
);

GO