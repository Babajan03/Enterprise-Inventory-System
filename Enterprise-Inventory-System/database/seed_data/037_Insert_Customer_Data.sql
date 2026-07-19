USE InventoryManagementDB;
GO


INSERT INTO sales.Customer
(
    CustomerCode,
    CustomerName,
    Email,
    PhoneNumber,
    AddressLine1,
    City,
    State,
    Country,
    PostalCode,
    CreatedBy
)
VALUES
(
    'CUS001',
    'ABC Technologies',
    'contact@abctech.com',
    '9000000011',
    'MG Road',
    'Hyderabad',
    'Telangana',
    'India',
    '500001',
    'SYSTEM'
),
(
    'CUS002',
    'XYZ Solutions',
    'sales@xyzsolutions.com',
    '9000000012',
    'Electronic City',
    'Bangalore',
    'Karnataka',
    'India',
    '560100',
    'SYSTEM'
);
GO