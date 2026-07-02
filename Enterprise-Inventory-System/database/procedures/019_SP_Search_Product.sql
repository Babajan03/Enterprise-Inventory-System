/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Search_Product
Script Name  : 019_SP_Search_Product.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Search_Product

    @ProductName NVARCHAR(200)=NULL,
    @CategoryID INT=NULL,
    @BrandID INT=NULL,
    @IsActive BIT=NULL

AS
BEGIN

SET NOCOUNT ON;

SELECT

P.ProductID,
P.ProductCode,
P.ProductName,
C.CategoryName,
B.BrandName,
P.SellingPrice,
P.IsActive

FROM master.Product P

INNER JOIN master.Category C
ON P.CategoryID=C.CategoryID

INNER JOIN master.Brand B
ON P.BrandID=B.BrandID

WHERE

(@ProductName IS NULL OR P.ProductName LIKE '%'+@ProductName+'%')

AND

(@CategoryID IS NULL OR P.CategoryID=@CategoryID)

AND

(@BrandID IS NULL OR P.BrandID=@BrandID)

AND

(@IsActive IS NULL OR P.IsActive=@IsActive)

ORDER BY

P.ProductName;

END
GO




EXEC master.SP_Search_Product;

EXEC master.SP_Search_Product
@ProductName='Dell';

EXEC master.SP_Search_Product
@IsActive=1;

EXEC master.SP_Search_Product
@CategoryID=1;