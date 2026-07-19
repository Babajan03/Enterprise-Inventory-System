USE InventoryManagementDB;
GO


CREATE OR ALTER VIEW report.VW_Purchase_History
AS


SELECT

    PO.PurchaseOrderId,

    PO.OrderNumber,

    S.SupplierName,

    PO.OrderDate,

    PO.Status,

    POD.ProductId,

    P.ProductName,

    POD.Quantity,

    POD.UnitPrice,

    (POD.Quantity * POD.UnitPrice) AS TotalValue


FROM purchase.PurchaseOrderHeader PO


INNER JOIN purchase.Supplier S
ON PO.SupplierId = S.SupplierId


INNER JOIN purchase.PurchaseOrderDetail POD
ON PO.PurchaseOrderId = POD.PurchaseOrderId


INNER JOIN master.Product P
ON POD.ProductId = P.ProductID;


GO