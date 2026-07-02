/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Supplier Management
Object Name  : ProductSupplier
Script Name  : 024_Insert_ProductSupplier_Data.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Maps products to suppliers with purchase information.
==============================================================================
*/

USE InventoryManagementDB;
GO

INSERT INTO master.ProductSupplier
(
    ProductID,
    SupplierID,
    SupplierProductCode,
    PurchasePrice,
    LeadTimeDays,
    IsPreferredSupplier
)
VALUES

-- Dell Laptop
(1,1,'DELL-LAP-001',44500.00,5,1),

-- HP Laptop
(2,2,'HP-LAP-001',47500.00,4,1),

-- Logitech Mouse
(3,3,'LOG-MOU-001',430.00,3,1),

-- Dell Keyboard
(4,1,'DELL-KB-001',580.00,5,1),

-- Samsung Monitor
(5,4,'SAM-MON-001',6900.00,6,1),

-- Seagate HDD
(6,5,'SEA-HDD-001',2700.00,7,1),

-- WD SSD
(7,5,'WD-SSD-001',3400.00,7,1),

-- Canon Printer
(8,2,'CAN-PRN-001',8300.00,6,1),

-- TP-Link Router
(9,5,'TPL-RT-001',1700.00,5,1),

-- Cisco Switch
(10,5,'CIS-SW-001',4000.00,8,1),

-- Lenovo Laptop supplied by Dell India (alternate supplier example)
(11,1,'LEN-LAP-001',54500.00,5,0);
GO

PRINT 'Product-Supplier mapping inserted successfully.';
GO





SELECT
    PS.ProductSupplierID,
    P.ProductName,
    S.SupplierName,
    PS.PurchasePrice,
    PS.LeadTimeDays,
    PS.IsPreferredSupplier
FROM master.ProductSupplier PS
INNER JOIN master.Product P
    ON PS.ProductID = P.ProductID
INNER JOIN master.Supplier S
    ON PS.SupplierID = S.SupplierID
ORDER BY P.ProductName;