/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Database
Script Name  : 002_Create_Schemas.sql
Author       : Shaik Babajan
Created Date : 2026-06-30
Version      : 1.0

Description:
Creates all application schemas used by the Enterprise Inventory
Management System.

Modification History

Version    Date          Author            Description
-------    ----------    ----------------  ------------------------------
1.0        2026-06-30    Shaik Babajan     Initial creation
==============================================================================
*/

USE InventoryManagementDB;
GO

PRINT 'Creating Schemas...';
GO

CREATE SCHEMA master;
GO

CREATE SCHEMA purchase;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA inventory;
GO

CREATE SCHEMA audit;
GO

CREATE SCHEMA report;
GO

PRINT 'All Schemas Created Successfully.';
GO