USE InventoryManagementDB;
GO


CREATE OR ALTER VIEW report.VW_Product_Master
AS

SELECT

    P.ProductID,

    P.ProductCode,

    P.ProductName,

    P.SKU,

    P.Barcode,

    C.CategoryName,

    B.BrandName,

    U.UnitName,

    P.CostPrice,

    P.SellingPrice,

    P.MinimumStock,

    P.MaximumStock,

    P.IsActive,

    P.CreatedDate


FROM master.Product P


LEFT JOIN master.Category C
ON P.CategoryID = C.CategoryID


LEFT JOIN master.Brand B
ON P.BrandID = B.BrandID


LEFT JOIN master.Unit U
ON P.UnitID = U.UnitID;

GO