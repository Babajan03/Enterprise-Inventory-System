USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE sales.SP_Create_Sales_Order
(
    @CustomerId INT,
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

SET NOCOUNT ON;


DECLARE @OrderNumber VARCHAR(30);


SET @OrderNumber =
'SORD-' + FORMAT(GETDATE(),'yyyyMMddHHmmss');


INSERT INTO sales.SalesOrderHeader
(
    OrderNumber,
    CustomerId,
    CreatedBy
)
VALUES
(
    @OrderNumber,
    @CustomerId,
    @CreatedBy
);


SELECT SCOPE_IDENTITY() AS SalesOrderId,
       @OrderNumber AS OrderNumber;

END;
GO