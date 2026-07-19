USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE report.SP_Product_Movement_Report
(
    @ProductId INT = NULL
)
AS
BEGIN

SET NOCOUNT ON;


SELECT


    P.ProductCode,

    P.ProductName,


    IT.TransactionType,


    IT.Quantity,


    IT.TransactionDate,


    IT.ReferenceNumber,


    IT.Remarks,


    IT.CreatedBy


FROM inventory.InventoryTransaction IT


INNER JOIN inventory.Inventory I

ON IT.InventoryId = I.InventoryId


INNER JOIN master.Product P

ON I.ProductId = P.ProductID


WHERE

(
    @ProductId IS NULL
    OR P.ProductID = @ProductId
)


ORDER BY IT.TransactionDate DESC;


END;
GO