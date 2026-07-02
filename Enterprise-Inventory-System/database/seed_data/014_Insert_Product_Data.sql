/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Script Name  : 014_Insert_Product_Data.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

INSERT INTO master.Product
(
    ProductCode,
    ProductName,
    ProductDescription,
    SKU,
    Barcode,
    HSNCode,
    CategoryID,
    BrandID,
    UnitID,
    TaxID,
    CurrencyID,
    CostPrice,
    SellingPrice,
    MinimumStock,
    MaximumStock,
    ReorderLevel
)
VALUES

('PRD0001','Dell Inspiron 15','Dell Laptop','SKU0001','890100000001','847130',1,1,1,4,1,45000,52000,5,100,10),

('PRD0002','HP Pavilion 14','HP Laptop','SKU0002','890100000002','847130',1,2,1,4,1,48000,56000,5,100,10),

('PRD0003','Logitech M185 Mouse','Wireless Mouse','SKU0003','890100000003','847160',2,3,1,4,1,450,650,20,500,50),

('PRD0004','Dell Keyboard KB216','USB Keyboard','SKU0004','890100000004','847160',2,1,1,4,1,600,850,20,500,50),

('PRD0005','Samsung 24 Monitor','24 Inch LED Monitor','SKU0005','890100000005','852852',3,4,1,4,1,7000,9000,5,50,10),

('PRD0006','Seagate 1TB HDD','Hard Disk','SKU0006','890100000006','847170',4,5,1,4,1,2800,3500,10,100,20),

('PRD0007','WD SSD 512GB','Solid State Drive','SKU0007','890100000007','847170',4,6,1,4,1,3500,4300,10,100,20),

('PRD0008','Canon Printer','Laser Printer','SKU0008','890100000008','844332',5,7,1,4,1,8500,10200,3,25,5),

('PRD0009','TP-Link Router','WiFi Router','SKU0009','890100000009','851762',6,8,1,4,1,1800,2400,10,100,20),

('PRD0010','Cisco Switch 8 Port','Network Switch','SKU0010','890100000010','851762',6,9,1,4,1,4200,5200,5,50,10);
GO

PRINT 'Product master data inserted successfully.';
GO