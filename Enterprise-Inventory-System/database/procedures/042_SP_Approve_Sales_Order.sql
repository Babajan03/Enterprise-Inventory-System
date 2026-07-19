USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE sales.SP_Approve_Sales_Order
(
    @SalesOrderId INT,
    @ApprovedBy VARCHAR(50)
)
AS
BEGIN

SET NOCOUNT ON;


UPDATE sales.SalesOrderHeader
SET
    OrderStatus = 'APPROVED',
    CreatedBy = @ApprovedBy
WHERE SalesOrderId = @SalesOrderId;


SELECT *
FROM sales.SalesOrderHeader
WHERE SalesOrderId = @SalesOrderId;


END;
GO