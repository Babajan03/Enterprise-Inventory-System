USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE report.SP_Monthly_Sales_Trends
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(h.OrderDate)                           AS SalesYear,
        MONTH(h.OrderDate)                          AS SalesMonth,
        FORMAT(h.OrderDate, 'MMM yyyy')             AS MonthLabel,
        COUNT(h.SalesOrderId)                       AS TotalOrders,
        ISNULL(SUM(h.TotalAmount), 0)               AS TotalRevenue,
        ISNULL(SUM(d.TotalQuantity), 0)             AS TotalUnitsSold
    FROM sales.SalesOrderHeader h
    OUTER APPLY (
        SELECT SUM(Quantity) AS TotalQuantity
        FROM sales.SalesOrderDetail
        WHERE SalesOrderId = h.SalesOrderId
    ) d
    WHERE h.OrderDate >= DATEADD(MONTH, -12, GETDATE())
    GROUP BY
        YEAR(h.OrderDate),
        MONTH(h.OrderDate),
        FORMAT(h.OrderDate, 'MMM yyyy')
    ORDER BY
        SalesYear ASC,
        SalesMonth ASC;
END;
GO
