USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE report.SP_Top_Selling_Products
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        p.ProductCode,
        p.ProductName,
        c.CategoryName,
        SUM(d.Quantity)                             AS TotalQuantitySold,
        SUM(d.Quantity * d.UnitPrice)               AS TotalRevenue
    FROM sales.SalesOrderDetail d
    INNER JOIN master.Product p
        ON d.ProductId = p.ProductID
    LEFT JOIN master.Category c
        ON p.CategoryID = c.CategoryID
    GROUP BY
        p.ProductCode,
        p.ProductName,
        c.CategoryName
    ORDER BY
        TotalRevenue DESC;
END;
GO
