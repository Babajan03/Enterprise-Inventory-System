USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE sales.SP_Ship_Sales_Order
(
    @SalesOrderId INT,
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRANSACTION;


BEGIN TRY


DECLARE 
@ProductId INT,
@Quantity DECIMAL(18,2),
@InventoryId INT;



SELECT
    @ProductId = ProductId,
    @Quantity = Quantity
FROM sales.SalesOrderDetail
WHERE SalesOrderId = @SalesOrderId;



SELECT 
    @InventoryId = InventoryId
FROM inventory.Inventory
WHERE ProductId = @ProductId;



IF EXISTS
(
    SELECT 1
    FROM inventory.Inventory
    WHERE InventoryId = @InventoryId
    AND Quantity < @Quantity
)
BEGIN

    THROW 50001,
    'Insufficient Inventory',
    1;

END



UPDATE inventory.Inventory
SET
    Quantity = Quantity - @Quantity,
    LastUpdatedDate = SYSDATETIME(),
    ModifiedDate = SYSDATETIME(),
    ModifiedBy = @CreatedBy
WHERE InventoryId = @InventoryId;



INSERT INTO inventory.InventoryTransaction
(
    InventoryId,
    TransactionType,
    Quantity,
    ReferenceNumber,
    CreatedBy
)
VALUES
(
    @InventoryId,
    'SALES_SHIPMENT',
    @Quantity,
    CAST(@SalesOrderId AS VARCHAR(50)),
    @CreatedBy
);



UPDATE sales.SalesOrderHeader
SET
    OrderStatus = 'SHIPPED'
WHERE SalesOrderId = @SalesOrderId;



COMMIT TRANSACTION;


END TRY


BEGIN CATCH

ROLLBACK TRANSACTION;
THROW;

END CATCH


END;
GO