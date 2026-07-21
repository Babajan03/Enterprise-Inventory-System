USE InventoryManagementDB;
GO


CREATE OR ALTER VIEW report.VW_Sales_History
AS


SELECT


    SO.SalesOrderId,

    SO.OrderNumber,

    C.CustomerCode,

    C.CustomerName,

    SO.OrderDate,

    SO.OrderStatus,

    P.ProductCode,

    P.ProductName,

    SOD.Quantity,

    SOD.UnitPrice,

    SOD.TotalPrice


FROM sales.SalesOrderHeader SO


INNER JOIN sales.Customer C

ON SO.CustomerId = C.CustomerId


INNER JOIN sales.SalesOrderDetail SOD

ON SO.SalesOrderId = SOD.SalesOrderId


INNER JOIN master.Product P

ON SOD.ProductId = P.ProductID;


GO


SELECT *
FROM report.VW_Current_Inventory;


SELECT *
FROM report.VW_Product_Master;


SELECT *
FROM report.VW_Sales_History;