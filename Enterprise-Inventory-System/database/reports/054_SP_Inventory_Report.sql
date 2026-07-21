USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE report.SP_Inventory_Report
AS
BEGIN

SET NOCOUNT ON;

SELECT

    W.WarehouseCode,

    W.WarehouseName,

    P.ProductCode,

    P.ProductName,

    I.Quantity,

    P.CostPrice,

    (I.Quantity * P.CostPrice) AS InventoryValue,

    CASE
        WHEN I.Quantity <= P.ReorderLevel
        THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS StockStatus

FROM inventory.Inventory I

INNER JOIN inventory.Warehouse W
ON I.WarehouseId = W.WarehouseId

INNER JOIN master.Product P
ON I.ProductId = P.ProductID;

END;
GO

EXEC report.SP_Inventory_Report;