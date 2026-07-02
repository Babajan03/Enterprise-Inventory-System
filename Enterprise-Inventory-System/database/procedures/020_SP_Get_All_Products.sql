/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Get_All_Products
Script Name  : 020_SP_Get_All_Products.sql
Author       : Shaik Babajan
Version      : 1.0

Description:
Returns all active products with lookup details.
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_All_Products
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        P.ProductID,
        P.ProductCode,
        P.ProductName,
        C.CategoryName,
        B.BrandName,
        U.UnitName,
        T.TaxName,
        CR.CurrencyCode,

        P.CostPrice,
        P.SellingPrice,

        P.MinimumStock,
        P.MaximumStock,
        P.ReorderLevel,

        P.IsActive,

        P.CreatedDate,
        P.ModifiedDate

    FROM master.Product P

    INNER JOIN master.Category C
        ON P.CategoryID = C.CategoryID

    INNER JOIN master.Brand B
        ON P.BrandID = B.BrandID

    INNER JOIN master.Unit U
        ON P.UnitID = U.UnitID

    INNER JOIN master.Tax T
        ON P.TaxID = T.TaxID

    INNER JOIN master.Currency CR
        ON P.CurrencyID = CR.CurrencyID

    WHERE P.IsActive = 1

    ORDER BY P.ProductName;

END
GO




EXEC master.SP_Get_All_Products;