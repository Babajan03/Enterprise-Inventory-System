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



USE InventoryManagementDB;
GO

SELECT
    OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName
FROM sys.indexes i
WHERE i.name IS NOT NULL
ORDER BY TableName, IndexName;



EXEC report.SP_Inventory_Report;


SELECT
    SPECIFIC_SCHEMA,
    SPECIFIC_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
AND SPECIFIC_SCHEMA='master'
ORDER BY SPECIFIC_NAME;

SELECT
    SPECIFIC_NAME,
    PARAMETER_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.PARAMETERS
WHERE SPECIFIC_SCHEMA='master'
AND SPECIFIC_NAME IN
(
'SP_Add_Product',
'SP_Update_Product',
'SP_Delete_Product',
'SP_Get_All_Products',
'SP_Get_Product_By_Id',
'SP_Search_Product'
)
ORDER BY SPECIFIC_NAME, ORDINAL_POSITION;


EXEC master.SP_Get_All_Products;


EXEC master.SP_Get_Product_By_Id @ProductID = 1;