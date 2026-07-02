/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Supplier Management
Object Name  : Supplier
Script Name  : 022_Insert_Supplier_Data.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Inserts initial supplier master data.
==============================================================================
*/

USE InventoryManagementDB;
GO

INSERT INTO master.Supplier
(
    SupplierCode,
    SupplierName,
    ContactPerson,
    Email,
    Phone,
    GSTNumber,
    AddressLine1,
    City,
    StateName,
    CountryName,
    PostalCode
)
VALUES
('SUP001','Dell India Pvt Ltd','Rajesh Kumar','sales@dellindia.com','9876543210','29ABCDE1234F1Z5','Outer Ring Road','Bengaluru','Karnataka','India','560037'),

('SUP002','HP India Sales Pvt Ltd','Amit Sharma','sales@hpindia.com','9876543211','29ABCDE1234F1Z6','Whitefield','Bengaluru','Karnataka','India','560066'),

('SUP003','Logitech India Pvt Ltd','Suresh Rao','sales@logitechindia.com','9876543212','29ABCDE1234F1Z7','MG Road','Bengaluru','Karnataka','India','560001'),

('SUP004','Samsung India Electronics','Ravi Kumar','sales@samsungindia.com','9876543213','29ABCDE1234F1Z8','Electronic City','Bengaluru','Karnataka','India','560100'),

('SUP005','Cisco Systems India','Priya Nair','sales@ciscoindia.com','9876543214','29ABCDE1234F1Z9','Embassy Tech Village','Bengaluru','Karnataka','India','560103');
GO

PRINT 'Supplier master data inserted successfully.';
GO



SELECT
    SupplierID,
    SupplierCode,
    SupplierName,
    City,
    StateName
FROM master.Supplier
ORDER BY SupplierID;