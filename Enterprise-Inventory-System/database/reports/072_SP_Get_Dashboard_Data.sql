USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE report.SP_Get_Dashboard_Data
AS
BEGIN
    SET NOCOUNT ON;

    -- Result Set 1: High Level KPI Metrics
    SELECT
        (SELECT COUNT(*) FROM master.Product WHERE IsActive = 1) AS TotalProducts,
        (SELECT COUNT(*) FROM master.Supplier WHERE IsActive = 1) AS TotalSuppliers,
        (SELECT COUNT(*) FROM sales.Customer WHERE IsActive = 1) AS TotalCustomers,
        (SELECT COUNT(*) FROM inventory.Warehouse WHERE IsActive = 1) AS TotalWarehouses,
        ISNULL((SELECT SUM(TotalAmount) FROM sales.SalesOrderHeader), 0) AS TotalSalesRevenue,
        ISNULL((SELECT SUM(TotalAmount) FROM purchase.PurchaseOrderHeader), 0) AS TotalPurchaseSpend,
        (SELECT COUNT(DISTINCT ProductId) FROM inventory.Inventory WHERE Quantity <= ReorderLevel) AS LowStockCount,
        ISNULL((SELECT SUM(i.Quantity * p.CostPrice) FROM inventory.Inventory i JOIN master.Product p ON i.ProductId = p.ProductID), 0) AS TotalInventoryValue;

    -- Result Set 2: Monthly Sales vs Purchase Trend (Last 6 Months)
    WITH Months AS (
        SELECT 5 AS MonthOffset UNION ALL SELECT 4 UNION ALL SELECT 3 
        UNION ALL SELECT 2 UNION ALL SELECT 1 UNION ALL SELECT 0
    )
    SELECT
        FORMAT(DATEADD(MONTH, -m.MonthOffset, GETDATE()), 'MMM yyyy') AS MonthLabel,
        YEAR(DATEADD(MONTH, -m.MonthOffset, GETDATE())) AS Yr,
        MONTH(DATEADD(MONTH, -m.MonthOffset, GETDATE())) AS Mn,
        ISNULL((
            SELECT SUM(TotalAmount) 
            FROM sales.SalesOrderHeader 
            WHERE YEAR(OrderDate) = YEAR(DATEADD(MONTH, -m.MonthOffset, GETDATE()))
              AND MONTH(OrderDate) = MONTH(DATEADD(MONTH, -m.MonthOffset, GETDATE()))
        ), 0) AS SalesAmount,
        ISNULL((
            SELECT SUM(TotalAmount) 
            FROM purchase.PurchaseOrderHeader 
            WHERE YEAR(OrderDate) = YEAR(DATEADD(MONTH, -m.MonthOffset, GETDATE()))
              AND MONTH(OrderDate) = MONTH(DATEADD(MONTH, -m.MonthOffset, GETDATE()))
        ), 0) AS PurchaseAmount
    FROM Months m
    ORDER BY Yr ASC, Mn ASC;

    -- Result Set 3: Stock Status Distribution
    SELECT
        SUM(CASE WHEN Quantity > ReorderLevel THEN 1 ELSE 0 END) AS HealthyStockCount,
        SUM(CASE WHEN Quantity > 0 AND Quantity <= ReorderLevel THEN 1 ELSE 0 END) AS LowStockCount,
        SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS OutOfStockCount
    FROM inventory.Inventory;

    -- Result Set 4: Recent Sales Orders (Top 5)
    SELECT TOP 5
        h.SalesOrderId,
        h.OrderNumber,
        c.CustomerName,
        h.OrderDate,
        h.TotalAmount,
        h.OrderStatus
    FROM sales.SalesOrderHeader h
    JOIN sales.Customer c ON h.CustomerId = c.CustomerId
    ORDER BY h.OrderDate DESC;

    -- Result Set 5: Urgent Low Stock Items (Top 5)
    SELECT TOP 5
        p.ProductCode,
        p.ProductName,
        w.WarehouseName,
        i.Quantity AS CurrentStock,
        p.ReorderLevel
    FROM inventory.Inventory i
    JOIN master.Product p ON i.ProductId = p.ProductID
    JOIN inventory.Warehouse w ON i.WarehouseId = w.WarehouseId
    WHERE i.Quantity <= p.ReorderLevel
    ORDER BY (i.ReorderLevel - i.Quantity) DESC;

END;
GO
