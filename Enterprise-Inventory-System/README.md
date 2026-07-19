# Enterprise Inventory Management System (EIMS)

## Overview

Enterprise Inventory Management System (EIMS) is a production-style SQL Server project developed to simulate real-world inventory operations. It demonstrates database design, normalization, business workflows, reporting, auditing, and performance optimization.

---

## Business Problem

Organizations require an efficient inventory management solution to:

- Maintain product master data
- Track warehouse inventory
- Manage purchase orders
- Process sales orders
- Record inventory transactions
- Generate operational reports
- Maintain audit history

This project addresses these requirements using SQL Server database objects and enterprise design practices.

---

## Technology Stack

- Microsoft SQL Server 2022
- SQL Server Management Studio (SSMS)
- Git & GitHub
- Visual Studio Code

---

## Database Architecture

The project is organized using multiple schemas.

| Schema | Purpose |
|---------|----------|
| master | Master Data |
| purchase | Purchase Management |
| inventory | Inventory Management |
| sales | Sales Management |
| audit | Audit Logs |
| report | Reporting |

---

## Features

- Product Management
- Warehouse Management
- Inventory Tracking
- Purchase Orders
- Sales Orders
- Goods Receipt
- Inventory Adjustment
- Inventory Transfer
- Reporting
- Auditing
- Performance Optimization

---

## Modules

### Master Module

- Product
- Category
- Brand
- Supplier
- Unit
- Tax
- Currency

### Purchase Module

- Purchase Order Header
- Purchase Order Detail
- Goods Receiving

### Inventory Module

- Warehouse
- Inventory
- Inventory Transactions
- Stock Adjustment
- Stock Transfer

### Sales Module

- Customer
- Sales Orders
- Shipment Processing

### Reporting Module

- Current Inventory
- Purchase History
- Sales History
- Low Stock Report
- Product Movement Report

### Audit Module

- Product Audit
- Inventory Audit

---

## SQL Features Used

- Stored Procedures
- Views
- Scalar Functions
- Triggers
- Transactions
- Primary Keys
- Foreign Keys
- Constraints
- Nonclustered Indexes

---

## Folder Structure

```text
database/
docs/
diagrams/
samples/
README.md
```

---

## Installation

1. Clone repository

```bash
git clone https://github.com/Babajan03/Enterprise-Inventory-System.git
```

2. Execute SQL scripts sequentially.

001_Create_Database.sql

↓

002_Create_Schemas.sql

↓

Master Tables

↓

Purchase Module

↓

Inventory Module

↓

Sales Module

↓

Functions

↓

Views

↓

Triggers

↓

Reports

↓

Indexes

---

## Sample Reports

- Inventory Report
- Low Stock Report
- Product Movement Report
- Sales History
- Purchase History

---

## Screenshots

### Database Architecture

![Architecture](diagrams/Database_Architecture.png)

### ER Diagram

![ER Diagram](diagrams/EIMS_ER_Diagram.png)

### Product Table

![Product](docs/screenshots/product-table.png)

### Inventory

![Inventory](docs/screenshots/inventory-table.png)

### Warehouse

![Warehouse](docs/screenshots/warehouse-table.png)

### Inventory Report

![Inventory Report](docs/screenshots/inventory-report.png)

### Product Movement Report

![Movement Report](docs/screenshots/product-movement-report.png)

---

## Future Enhancements

- REST API Integration
- Power BI Dashboard
- Role-Based Security
- Automated Backup
- Azure SQL Deployment
- CI/CD Pipeline

---

## Author

**Shaik Babajan**

SQL Developer

GitHub: https://github.com/Babajan03