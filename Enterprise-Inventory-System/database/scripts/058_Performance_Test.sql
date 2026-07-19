USE InventoryManagementDB;
GO


SET STATISTICS TIME ON;

SET STATISTICS IO ON;



-- Inventory Report Test

EXEC report.SP_Inventory_Report;



-- Sales History Test

SELECT *
FROM report.VW_Sales_History;



-- Purchase History Test

SELECT *
FROM report.VW_Purchase_History;



-- Product Search Test

SELECT *
FROM master.Product
WHERE ProductCode = 'PRD0001';



SET STATISTICS TIME OFF;

SET STATISTICS IO OFF;

GO