/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Get_Product_By_Id
Script Name  : 018_SP_Get_Product_By_Id.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_Product_By_Id

    @ProductID INT

AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        P.ProductID,
        P.ProductCode,
        P.ProductName,
        P.ProductDescription,
        P.SKU,
        P.Barcode,
        P.HSNCode,

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
        P.CreatedBy,
        P.ModifiedDate,
        P.ModifiedBy

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

    WHERE P.ProductID = @ProductID;

END
GO


EXEC master.SP_Get_Product_By_Id
    @ProductID = 2;