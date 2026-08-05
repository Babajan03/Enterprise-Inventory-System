USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_Stock_Transfers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        ST.TransferID,
        ST.TransferNumber,
        P.ProductName,
        W1.WarehouseName AS FromWarehouse,
        W2.WarehouseName AS ToWarehouse,
        ST.Quantity,
        ST.TransferDate,
        ST.Status,
        U.Username AS RequestedBy
    FROM master.StockTransfer ST
    JOIN master.Product P ON ST.ProductID = P.ProductID
    JOIN inventory.Warehouse W1 ON ST.FromWarehouseID = W1.WarehouseId
    JOIN inventory.Warehouse W2 ON ST.ToWarehouseID = W2.WarehouseId
    LEFT JOIN master.[User] U ON ST.RequestedBy = U.UserID
    ORDER BY ST.TransferDate DESC;
END;
GO
