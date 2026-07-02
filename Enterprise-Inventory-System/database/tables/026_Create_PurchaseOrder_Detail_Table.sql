/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Purchase Management
Object Name  : PurchaseOrderDetail
Script Name  : 026_Create_PurchaseOrder_Detail_Table.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

IF OBJECT_ID('purchase.PurchaseOrderDetail','U') IS NOT NULL
DROP TABLE purchase.PurchaseOrderDetail;
GO

CREATE TABLE purchase.PurchaseOrderDetail
(
    PurchaseOrderDetailID INT IDENTITY(1,1) NOT NULL,

    PurchaseOrderID INT NOT NULL,

    ProductID INT NOT NULL,

    OrderedQuantity DECIMAL(18,2) NOT NULL,

    UnitPrice DECIMAL(18,2) NOT NULL,

    DiscountAmount DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_POD_Discount DEFAULT(0),

    TaxAmount DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_POD_Tax DEFAULT(0),

    LineTotal DECIMAL(18,2) NOT NULL,

    ReceivedQuantity DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_POD_Received DEFAULT(0),

    Remarks NVARCHAR(250) NULL,

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_POD_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_POD_CreatedBy DEFAULT(SUSER_SNAME()),

    RowVersion ROWVERSION,

    CONSTRAINT PK_PurchaseOrderDetail
        PRIMARY KEY(PurchaseOrderDetailID),

    CONSTRAINT FK_POD_Header
        FOREIGN KEY(PurchaseOrderID)
        REFERENCES purchase.PurchaseOrderHeader(PurchaseOrderID),

    CONSTRAINT FK_POD_Product
        FOREIGN KEY(ProductID)
        REFERENCES master.Product(ProductID),

    CONSTRAINT CK_POD_OrderedQty
        CHECK(OrderedQuantity > 0),

    CONSTRAINT CK_POD_UnitPrice
        CHECK(UnitPrice >= 0),

    CONSTRAINT CK_POD_Discount
        CHECK(DiscountAmount >= 0),

    CONSTRAINT CK_POD_Tax
        CHECK(TaxAmount >= 0),

    CONSTRAINT CK_POD_LineTotal
        CHECK(LineTotal >= 0),

    CONSTRAINT CK_POD_ReceivedQty
        CHECK(ReceivedQuantity >= 0)
);
GO

PRINT 'PurchaseOrderDetail created successfully.';
GO




SELECT *
FROM purchase.PurchaseOrderDetail;