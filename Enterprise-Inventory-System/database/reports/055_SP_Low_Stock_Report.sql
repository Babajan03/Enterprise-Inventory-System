USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE report.SP_Low_Stock_Report
AS
BEGIN

SET NOCOUNT ON;


SELECT


    P.ProductCode,

    P.ProductName,

    W.WarehouseName,

    I.Quantity AS CurrentStock,

    P.ReorderLevel,


    (P.ReorderLevel - I.Quantity)
        AS RequiredQuantity


FROM inventory.Inventory I


INNER JOIN master.Product P
ON I.ProductId = P.ProductID


INNER JOIN inventory.Warehouse W
ON I.WarehouseId = W.WarehouseId


WHERE I.Quantity <= P.ReorderLevel;


END;
GO