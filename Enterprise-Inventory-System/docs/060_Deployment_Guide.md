# Enterprise Inventory Management System
# Deployment Guide


## Prerequisites

- SQL Server 2022
- SQL Server Management Studio


## Deployment Steps


1. Create Database

Run:

001_Create_Database.sql


2. Create Schemas

Run:

002_Create_Schemas.sql


3. Execute Scripts Sequentially


Database Creation
|
Master Data
|
Purchase Module
|
Inventory Module
|
Sales Module
|
Reporting
|
Audit
|
Indexes


## Validation


Check tables:

SELECT *
FROM INFORMATION_SCHEMA.TABLES;


Check procedures:

SELECT *
FROM sys.procedures;


## Backup Recommendation

Take database backup after successful deployment.