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



EXEC sales.SP_Create_Sales_Order
    @CustomerId = 1,
    @CreatedBy = 'SYSTEM';


    EXEC sales.SP_Add_Sales_Order_Item
    @SalesOrderId = 1,
    @ProductId = 1,
    @Quantity = 2,
    @UnitPrice = 55000,
    @CreatedBy = 'SYSTEM';


    EXEC sales.SP_Approve_Sales_Order
    @SalesOrderId = 1,
    @ApprovedBy = 'SYSTEM';



    EXEC sales.SP_Ship_Sales_Order
    @SalesOrderId = 1,
    @CreatedBy = 'SYSTEM';


    SELECT *
FROM sales.SalesOrderHeader;


SELECT *
FROM sales.SalesOrderDetail;


SELECT *
FROM inventory.Inventory;


SELECT *
FROM inventory.InventoryTransaction;



SELECT *
FROM sales.Customer;

SELECT *
FROM sales.Customer;

EXEC sales.SP_Create_Sales_Order
    @CustomerId = 1,
    @CreatedBy = 'SYSTEM';
    

    EXEC sales.SP_Add_Sales_Order_Item
    @SalesOrderId = 1,
    @ProductId = 1,
    @Quantity = 2,
    @UnitPrice = 55000,
    @CreatedBy = 'SYSTEM';


    SELECT *
FROM sales.SalesOrderDetail;

EXEC sales.SP_Approve_Sales_Order
    @SalesOrderId = 1,
    @ApprovedBy = 'SYSTEM';

    SELECT 
    SalesOrderId,
    OrderStatus,
    TotalAmount
FROM sales.SalesOrderHeader;


EXEC sales.SP_Ship_Sales_Order
    @SalesOrderId = 1,
    @CreatedBy = 'SYSTEM';



    SELECT *
FROM sales.SalesOrderHeader;


SELECT *
FROM sales.SalesOrderDetail;


SELECT *
FROM inventory.Inventory;


SELECT *
FROM inventory.InventoryTransaction;


SELECT *
FROM sales.SalesOrderHeader;

SELECT *
FROM sales.SalesOrderDetail
WHERE SalesOrderId = 1;