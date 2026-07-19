USE InventoryManagementDB;
GO


CREATE OR ALTER VIEW report.VW_Current_Inventory
AS

SELECT

    I.InventoryId,

    W.WarehouseCode,

    W.WarehouseName,

    P.ProductCode,

    P.ProductName,

    I.Quantity,

    I.ReorderLevel,

    CASE
        WHEN I.Quantity <= I.ReorderLevel
        THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS StockStatus,

    I.LastUpdatedDate


FROM inventory.Inventory I

INNER JOIN inventory.Warehouse W
ON I.WarehouseId = W.WarehouseId

INNER JOIN master.Product P
ON I.ProductId = P.ProductID;

GO