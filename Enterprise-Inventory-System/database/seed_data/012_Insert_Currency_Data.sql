/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Master Data
Schema       : master
Object Name  : Currency
Script Name  : 012_Insert_Currency_Data.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Inserts seed data into the Currency master table.
==============================================================================
*/

USE InventoryManagementDB;
GO

INSERT INTO master.Currency
(
    CurrencyCode,
    CurrencyName,
    CurrencySymbol,
    CountryName
)
VALUES
('INR', 'Indian Rupee', '₹', 'India'),
('USD', 'US Dollar', '$', 'United States'),
('EUR', 'Euro', '€', 'European Union'),
('GBP', 'British Pound', '£', 'United Kingdom'),
('AED', 'UAE Dirham', 'AED', 'United Arab Emirates');
GO

PRINT 'Currency master data inserted successfully.';
GO



SELECT *
FROM master.Currency
ORDER BY CurrencyCode;