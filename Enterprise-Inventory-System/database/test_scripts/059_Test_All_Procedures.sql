USE InventoryManagementDB;
GO


PRINT '================================';
PRINT 'EIMS PROCEDURE TEST START';
PRINT '================================';



-- Inventory Report

EXEC report.SP_Inventory_Report;



-- Low Stock Report

EXEC report.SP_Low_Stock_Report;



-- Product Movement

EXEC report.SP_Product_Movement_Report
    @ProductId = 1;



-- Current Stock Function

SELECT 
inventory.FN_Get_Current_Stock
(
    1,
    1
)
AS CurrentStock;



-- Product Value Function

SELECT
inventory.FN_Product_Value(1)
AS ProductValue;



PRINT '================================';
PRINT 'EIMS TEST COMPLETED';
PRINT '================================';


GO