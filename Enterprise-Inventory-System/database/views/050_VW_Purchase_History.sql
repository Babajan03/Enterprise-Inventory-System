USE InventoryManagementDB;
GO

/*
    View Name   : report.VW_Purchase_History
    Purpose     : Purchase transaction reporting
    Module      : Reporting
*/


CREATE OR ALTER VIEW report.VW_Purchase_History
AS

SELECT

    PO.PurchaseOrderID,

    PO.PurchaseOrderNumber,

    S.SupplierCode,

    S.SupplierName,

    PO.OrderDate,

    PO.Status,

    P.ProductCode,

    P.ProductName,

    POD.OrderedQuantity,

    POD.ReceivedQuantity,

    POD.UnitPrice,

    POD.DiscountAmount,

    POD.TaxAmount,

    POD.LineTotal,

    PO.TotalAmount


FROM purchase.PurchaseOrderHeader PO


INNER JOIN purchase.Supplier S
ON PO.SupplierID = S.SupplierId


INNER JOIN purchase.PurchaseOrderDetail POD
ON PO.PurchaseOrderID = POD.PurchaseOrderID


INNER JOIN master.Product P
ON POD.ProductID = P.ProductID;

GO


SELECT 
    name,
    schema_id
FROM sys.schemas;


USE InventoryManagementDB;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'purchase'



USE InventoryManagementDB;
GO

EXEC sp_help 'purchase.PurchaseOrderHeader';

EXEC sp_help 'purchase.PurchaseOrderDetail';

EXEC sp_help 'purchase.Supplier';



USE InventoryManagementDB;
GO

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'purchase'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


SELECT *
FROM report.VW_Purchase_History;

SELECT *
FROM purchase.PurchaseOrderHeader;

SELECT *
FROM purchase.PurchaseOrderDetail;

USE InventoryManagementDB;
GO


INSERT INTO purchase.PurchaseOrderDetail
(
    PurchaseOrderID,
    ProductID,
    OrderedQuantity,
    UnitPrice,
    DiscountAmount,
    TaxAmount,
    LineTotal,
    ReceivedQuantity,
    Remarks,
    CreatedBy
)
VALUES
(
    1,
    1,
    50,
    47000,
    0,
    0,
    2350000,
    0,
    'Initial stock purchase',
    'SYSTEM'
);
GO


UPDATE purchase.PurchaseOrderHeader
SET TotalAmount =
(
    SELECT SUM(LineTotal)
    FROM purchase.PurchaseOrderDetail
    WHERE PurchaseOrderID = 1
)
WHERE PurchaseOrderID = 1;


SELECT *
FROM report.VW_Purchase_History;