USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE report.SP_Category_Sales_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ISNULL(c.CategoryName, 'Uncategorized')    AS CategoryName,
        COUNT(DISTINCT p.ProductID)                 AS TotalProducts,
        SUM(d.Quantity)                             AS TotalQuantitySold,
        ISNULL(SUM(d.Quantity * d.UnitPrice), 0)    AS TotalRevenue
    FROM sales.SalesOrderDetail d
    INNER JOIN master.Product p
        ON d.ProductId = p.ProductID
    LEFT JOIN master.Category c
        ON p.CategoryID = c.CategoryID
    GROUP BY
        c.CategoryName
    ORDER BY
        TotalRevenue DESC;
END;
GO
