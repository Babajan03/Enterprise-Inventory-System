/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Purchase Management
Object Name  : PurchaseOrderHeader
Script Name  : 025_Create_PurchaseOrder_Header_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('purchase.PurchaseOrderHeader','U') IS NOT NULL
DROP TABLE purchase.PurchaseOrderHeader;
GO

CREATE TABLE purchase.PurchaseOrderHeader
(
    PurchaseOrderID INT IDENTITY(1,1) NOT NULL,

    PurchaseOrderNumber VARCHAR(30) NOT NULL,

    SupplierID INT NOT NULL,

    OrderDate DATE NOT NULL,

    ExpectedDeliveryDate DATE NULL,

    TotalAmount DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_PO_TotalAmount DEFAULT(0),

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_PO_Status DEFAULT('Draft'),

    Remarks NVARCHAR(500) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_PO_IsActive DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_PO_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_PO_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    RowVersion ROWVERSION,

    CONSTRAINT PK_PurchaseOrderHeader
        PRIMARY KEY(PurchaseOrderID),

    CONSTRAINT UQ_PurchaseOrder_Number
        UNIQUE(PurchaseOrderNumber),

    CONSTRAINT FK_PurchaseOrder_Supplier
        FOREIGN KEY(SupplierID)
        REFERENCES master.Supplier(SupplierID),

    CONSTRAINT CK_PO_TotalAmount
        CHECK(TotalAmount >= 0),

    CONSTRAINT CK_PO_Status
        CHECK(Status IN
        (
            'Draft',
            'Submitted',
            'Approved',
            'Received',
            'Cancelled'
        ))
);

GO

PRINT 'PurchaseOrderHeader created successfully.';
GO



SELECT *
FROM purchase.PurchaseOrderHeader;