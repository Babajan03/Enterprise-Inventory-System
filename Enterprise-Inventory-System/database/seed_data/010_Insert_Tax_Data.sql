/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Tax
Script Name  : 010_Insert_Tax_Data.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Inserts seed data into the Tax master table.
==============================================================================
*/

USE InventoryManagementDB;
GO

INSERT INTO master.Tax
(
    TaxCode,
    TaxName,
    TaxPercentage,
    Description
)
VALUES
('GST0',  'GST 0%',  0.00,  'Tax Exempt'),
('GST5',  'GST 5%',  5.00,  'Low GST Rate'),
('GST12', 'GST 12%', 12.00, 'Standard GST Rate'),
('GST18', 'GST 18%', 18.00, 'General GST Rate'),
('GST28', 'GST 28%', 28.00, 'Luxury Goods GST');
GO

PRINT 'Tax master data inserted successfully.';
GO