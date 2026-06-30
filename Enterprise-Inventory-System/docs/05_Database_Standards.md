# Enterprise Inventory Management System (EIMS)

# Database Standards

Version: 1.0

---

# 1. Naming Standards

## Database

InventoryManagementDB

## Schemas

master
purchase
sales
inventory
audit
report

## Tables

Use singular names.

Examples:

Category
Brand
Product
Supplier
Warehouse

## Primary Keys

<TableName>ID

Examples:

CategoryID
BrandID
ProductID

## Foreign Keys

Use the same name as the referenced primary key.

Examples:

CategoryID
BrandID
SupplierID

---

# 2. Data Type Standards

Business Codes      -> VARCHAR
Names               -> NVARCHAR
Descriptions        -> NVARCHAR
Dates               -> DATETIME2
Boolean             -> BIT
Money               -> DECIMAL(18,2)
Primary Keys        -> INT IDENTITY
Version Column      -> ROWVERSION

---

# 3. Standard Audit Columns

Every master table must contain:

CreatedDate
CreatedBy
ModifiedDate
ModifiedBy
IsActive
RowVersion

---

# 4. Constraint Naming

Primary Key

PK_<TableName>

Example:

PK_Product

Unique Key

UQ_<TableName>_<ColumnName>

Example:

UQ_Product_ProductCode

Default Constraint

DF_<TableName>_<ColumnName>

Example:

DF_Product_IsActive

Foreign Key

FK_<ParentTable>_<ChildTable>

Example:

FK_Category_Product

---

# 5. Soft Delete Policy

Records are never physically deleted.

Inactive records will have:

IsActive = 0

---

# 6. Unicode Policy

Business names and descriptions must use NVARCHAR.

Business codes use VARCHAR.

---

# 7. Deployment Rules

Every object must have:

- Header comments
- Version
- Author
- Description
- Verification script

---

Status

Approved