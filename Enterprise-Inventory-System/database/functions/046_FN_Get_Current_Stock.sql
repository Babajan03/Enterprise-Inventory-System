USE InventoryManagementDB;
GO


CREATE OR ALTER FUNCTION inventory.FN_Get_Current_Stock
(
    @WarehouseId INT,
    @ProductId INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

DECLARE @Stock DECIMAL(18,2);


SELECT 
@Stock = Quantity

FROM inventory.Inventory

WHERE WarehouseId = @WarehouseId
AND ProductId = @ProductId;



RETURN ISNULL(@Stock,0);


END;
GO