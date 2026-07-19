USE InventoryManagementDB;
GO


CREATE OR ALTER FUNCTION inventory.FN_Product_Value
(
    @InventoryId INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN


DECLARE @Value DECIMAL(18,2);



SELECT

@Value =
I.Quantity * P.CostPrice


FROM inventory.Inventory I

INNER JOIN master.Product P
ON I.ProductId = P.ProductID


WHERE I.InventoryId = @InventoryId;



RETURN ISNULL(@Value,0);


END;
GO



INSERT INTO inventory.Inventory
(
    WarehouseId,
    ProductId,
    Quantity,
    ReorderLevel,
    CreatedBy
)
VALUES
(
    2,
    1,
    0,
    10,
    'SYSTEM'
);



SELECT *
FROM inventory.Inventory;

EXEC inventory.SP_Transfer_Inventory
    @FromInventoryId = 1,
    @ToInventoryId = 2,
    @Quantity = 10,
    @CreatedBy = 'SYSTEM';


    SELECT *
FROM inventory.Inventory;