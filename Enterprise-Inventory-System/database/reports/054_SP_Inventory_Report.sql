USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE report.SP_Inventory_Report
AS
BEGIN

SET NOCOUNT ON;

SELECT

    W.WarehouseCode,

    W.WarehouseName,

    P.ProductCode,

    P.ProductName,

    I.Quantity,

    P.CostPrice,

    (I.Quantity * P.CostPrice) AS InventoryValue,

    CASE
        WHEN I.Quantity <= P.ReorderLevel
        THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS StockStatus

FROM inventory.Inventory I

INNER JOIN inventory.Warehouse W
ON I.WarehouseId = W.WarehouseId

INNER JOIN master.Product P
ON I.ProductId = P.ProductID;

END;
GO

EXEC report.SP_Inventory_Report;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer'
AND TABLE_SCHEMA = 'master'
ORDER BY ORDINAL_POSITION;

USE InventoryManagementDB;
GO
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Customer%';


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Customer'



CREATE PROCEDURE sales.SP_Get_All_Customers
AS
BEGIN
    SELECT CustomerId, CustomerCode, CustomerName, Email,
           PhoneNumber, AddressLine1, City, State,
           Country, PostalCode, IsActive
    FROM sales.Customer
    ORDER BY CustomerName;
END


CREATE PROCEDURE sales.SP_Get_Customer_By_Id
    @CustomerId INT
AS
BEGIN
    SELECT CustomerId, CustomerCode, CustomerName, Email,
           PhoneNumber, AddressLine1, City, State,
           Country, PostalCode, IsActive
    FROM sales.Customer
    WHERE CustomerId = @CustomerId;
END



CREATE PROCEDURE sales.SP_Add_Customer
    @CustomerCode VARCHAR(20),
    @CustomerName VARCHAR(150),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @AddressLine1 VARCHAR(150),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @PostalCode VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    INSERT INTO sales.Customer
        (CustomerCode, CustomerName, Email, PhoneNumber,
         AddressLine1, City, State, Country, PostalCode,
         IsActive, CreatedDate, CreatedBy)
    VALUES
        (@CustomerCode, @CustomerName, @Email, @PhoneNumber,
         @AddressLine1, @City, @State, @Country, @PostalCode,
         @IsActive, GETDATE(), 'system');
END



CREATE PROCEDURE sales.SP_Update_Customer
    @CustomerId INT,
    @CustomerCode VARCHAR(20),
    @CustomerName VARCHAR(150),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @AddressLine1 VARCHAR(150),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @PostalCode VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    UPDATE sales.Customer
    SET CustomerCode = @CustomerCode,
        CustomerName = @CustomerName,
        Email = @Email,
        PhoneNumber = @PhoneNumber,
        AddressLine1 = @AddressLine1,
        City = @City,
        State = @State,
        Country = @Country,
        PostalCode = @PostalCode,
        IsActive = @IsActive,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE CustomerId = @CustomerId;
END




CREATE PROCEDURE sales.SP_Delete_Customer
    @CustomerId INT
AS
BEGIN
    UPDATE sales.Customer
    SET IsActive = 0,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE CustomerId = @CustomerId;
END

-- Inventory tables
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('Inventory', 'InventoryTransaction', 'Warehouse')
ORDER BY TABLE_SCHEMA, TABLE_NAME;


-- Purchase tables
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Purchase%'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- All columns for all these tables
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Inventory', 'InventoryTransaction', 'Warehouse', 'PurchaseOrder', 'PurchaseOrderHeader', 'PurchaseOrderDetail')
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;


CREATE PROCEDURE inventory.SP_Get_All_Warehouses
AS
BEGIN
    SELECT WarehouseId, WarehouseCode, WarehouseName, AddressLine1,
           City, State, Country, PostalCode, ContactPerson,
           ContactNumber, IsActive
    FROM inventory.Warehouse
    ORDER BY WarehouseName;
END



CREATE PROCEDURE inventory.SP_Get_Warehouse_By_Id
    @WarehouseId INT
AS
BEGIN
    SELECT WarehouseId, WarehouseCode, WarehouseName, AddressLine1,
           City, State, Country, PostalCode, ContactPerson,
           ContactNumber, IsActive
    FROM inventory.Warehouse
    WHERE WarehouseId = @WarehouseId;
END


CREATE PROCEDURE inventory.SP_Add_Warehouse
    @WarehouseCode VARCHAR(20),
    @WarehouseName VARCHAR(100),
    @AddressLine1 VARCHAR(150),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @PostalCode VARCHAR(20),
    @ContactPerson VARCHAR(100),
    @ContactNumber VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    INSERT INTO inventory.Warehouse
        (WarehouseCode, WarehouseName, AddressLine1, City, State,
         Country, PostalCode, ContactPerson, ContactNumber,
         IsActive, CreatedDate, CreatedBy)
    VALUES
        (@WarehouseCode, @WarehouseName, @AddressLine1, @City, @State,
         @Country, @PostalCode, @ContactPerson, @ContactNumber,
         @IsActive, GETDATE(), 'system');
END



CREATE PROCEDURE inventory.SP_Update_Warehouse
    @WarehouseId INT,
    @WarehouseCode VARCHAR(20),
    @WarehouseName VARCHAR(100),
    @AddressLine1 VARCHAR(150),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @PostalCode VARCHAR(20),
    @ContactPerson VARCHAR(100),
    @ContactNumber VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    UPDATE inventory.Warehouse
    SET WarehouseCode = @WarehouseCode,
        WarehouseName = @WarehouseName,
        AddressLine1 = @AddressLine1,
        City = @City,
        State = @State,
        Country = @Country,
        PostalCode = @PostalCode,
        ContactPerson = @ContactPerson,
        ContactNumber = @ContactNumber,
        IsActive = @IsActive,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE WarehouseId = @WarehouseId;
END



CREATE PROCEDURE inventory.SP_Delete_Warehouse
    @WarehouseId INT
AS
BEGIN
    UPDATE inventory.Warehouse
    SET IsActive = 0,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE WarehouseId = @WarehouseId;
END


CREATE PROCEDURE inventory.SP_Get_All_Inventory
AS
BEGIN
    SELECT i.InventoryId, i.WarehouseId, i.ProductId,
           i.Quantity, i.ReorderLevel, i.LastUpdatedDate,
           w.WarehouseName, p.ProductName, p.ProductCode
    FROM inventory.Inventory i
    JOIN inventory.Warehouse w ON i.WarehouseId = w.WarehouseId
    JOIN master.Product p ON i.ProductId = p.ProductID
    ORDER BY w.WarehouseName, p.ProductName;
END


CREATE OR ALTER PROCEDURE inventory.SP_Adjust_Inventory
    @InventoryId INT,
    @Quantity DECIMAL(18,2),
    @Remarks VARCHAR(200)
AS
BEGIN
    UPDATE inventory.Inventory
    SET Quantity = @Quantity,
        LastUpdatedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE InventoryId = @InventoryId;

    INSERT INTO inventory.InventoryTransaction
        (InventoryId, TransactionType, Quantity,
         TransactionDate, Remarks, CreatedBy)
    VALUES
        (@InventoryId, 'ADJUSTMENT', @Quantity,
         GETDATE(), @Remarks, 'system');
END


CREATE PROCEDURE purchase.SP_Get_All_Purchase_Orders
AS
BEGIN
    SELECT h.PurchaseOrderID, h.PurchaseOrderNumber,
           h.SupplierID, s.SupplierName,
           h.OrderDate, h.ExpectedDeliveryDate,
           h.TotalAmount, h.Status, h.Remarks, h.IsActive
    FROM purchase.PurchaseOrderHeader h
    JOIN master.Supplier s ON h.SupplierID = s.SupplierID
    ORDER BY h.OrderDate DESC;
END


CREATE PROCEDURE purchase.SP_Get_Purchase_Order_By_Id
    @PurchaseOrderID INT
AS
BEGIN
    SELECT h.PurchaseOrderID, h.PurchaseOrderNumber,
           h.SupplierID, s.SupplierName,
           h.OrderDate, h.ExpectedDeliveryDate,
           h.TotalAmount, h.Status, h.Remarks
    FROM purchase.PurchaseOrderHeader h
    JOIN master.Supplier s ON h.SupplierID = s.SupplierID
    WHERE h.PurchaseOrderID = @PurchaseOrderID;
END


CREATE PROCEDURE purchase.SP_Get_Purchase_Order_Items
    @PurchaseOrderID INT
AS
BEGIN
    SELECT d.PurchaseOrderDetailID, d.PurchaseOrderID,
           d.ProductID, p.ProductName, p.ProductCode,
           d.OrderedQuantity, d.UnitPrice,
           d.DiscountAmount, d.TaxAmount, d.LineTotal,
           d.ReceivedQuantity, d.Remarks
    FROM purchase.PurchaseOrderDetail d
    JOIN master.Product p ON d.ProductID = p.ProductID
    WHERE d.PurchaseOrderID = @PurchaseOrderID;
END

CREATE OR ALTER PROCEDURE purchase.SP_Create_Purchase_Order
    @PurchaseOrderNumber VARCHAR(50),
    @SupplierID INT,
    @OrderDate DATE,
    @ExpectedDeliveryDate DATE,
    @Remarks NVARCHAR(500)
AS
BEGIN
    INSERT INTO purchase.PurchaseOrderHeader
        (PurchaseOrderNumber, SupplierID, OrderDate,
         ExpectedDeliveryDate, TotalAmount, Status,
         Remarks, IsActive, CreatedDate, CreatedBy)
    VALUES
        (@PurchaseOrderNumber, @SupplierID, @OrderDate,
         @ExpectedDeliveryDate, 0, 'Draft',
         @Remarks, 1, GETDATE(), 'system');

    SELECT SCOPE_IDENTITY() AS PurchaseOrderID;
END


CREATE OR ALTER PROCEDURE purchase.SP_Add_Purchase_Order_Item
    @PurchaseOrderID INT,
    @ProductID INT,
    @OrderedQuantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @DiscountAmount DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2)
AS
BEGIN
    DECLARE @LineTotal DECIMAL(18,2);
    SET @LineTotal = (@OrderedQuantity * @UnitPrice) - @DiscountAmount + @TaxAmount;

    INSERT INTO purchase.PurchaseOrderDetail
        (PurchaseOrderID, ProductID, OrderedQuantity, UnitPrice,
         DiscountAmount, TaxAmount, LineTotal,
         ReceivedQuantity, CreatedDate, CreatedBy)
    VALUES
        (@PurchaseOrderID, @ProductID, @OrderedQuantity, @UnitPrice,
         @DiscountAmount, @TaxAmount, @LineTotal,
         0, GETDATE(), 'system');

    UPDATE purchase.PurchaseOrderHeader
    SET TotalAmount = (
        SELECT SUM(LineTotal) FROM purchase.PurchaseOrderDetail
        WHERE PurchaseOrderID = @PurchaseOrderID
    )
    WHERE PurchaseOrderID = @PurchaseOrderID;
END

CREATE PROCEDURE purchase.SP_Update_Purchase_Order_Status
    @PurchaseOrderID INT,
    @Status VARCHAR(50)
AS
BEGIN
    UPDATE purchase.PurchaseOrderHeader
    SET Status = @Status,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE PurchaseOrderID = @PurchaseOrderID;
END


SELECT COUNT(*) FROM sales.Customer;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Sales%'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('SalesOrderHeader', 'SalesOrderDetail')
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;


CREATE PROCEDURE sales.SP_Get_All_Sales_Orders
AS
BEGIN
    SELECT h.SalesOrderId, h.OrderNumber, h.CustomerId,
           c.CustomerName, h.OrderDate, h.OrderStatus,
           h.TotalAmount, h.CreatedDate
    FROM sales.SalesOrderHeader h
    JOIN sales.Customer c ON h.CustomerId = c.CustomerId
    ORDER BY h.OrderDate DESC;
END


CREATE PROCEDURE sales.SP_Get_Sales_Order_By_Id
    @SalesOrderId INT
AS
BEGIN
    SELECT h.SalesOrderId, h.OrderNumber, h.CustomerId,
           c.CustomerName, h.OrderDate, h.OrderStatus,
           h.TotalAmount
    FROM sales.SalesOrderHeader h
    JOIN sales.Customer c ON h.CustomerId = c.CustomerId
    WHERE h.SalesOrderId = @SalesOrderId;
END



CREATE PROCEDURE sales.SP_Get_Sales_Order_Items
    @SalesOrderId INT
AS
BEGIN
    SELECT d.SalesOrderDetailId, d.SalesOrderId,
           d.ProductId, p.ProductName, p.ProductCode,
           d.Quantity, d.UnitPrice, d.TotalPrice
    FROM sales.SalesOrderDetail d
    JOIN master.Product p ON d.ProductId = p.ProductID
    WHERE d.SalesOrderId = @SalesOrderId;
END



CREATE OR ALTER PROCEDURE sales.SP_Create_Sales_Order
    @OrderNumber VARCHAR(50),
    @CustomerId INT,
    @OrderDate DATETIME2,
    @OrderStatus VARCHAR(50)
AS
BEGIN
    INSERT INTO sales.SalesOrderHeader
        (OrderNumber, CustomerId, OrderDate, OrderStatus,
         TotalAmount, CreatedDate, CreatedBy)
    VALUES
        (@OrderNumber, @CustomerId, @OrderDate, @OrderStatus,
         0, GETDATE(), 'system');

    SELECT SCOPE_IDENTITY() AS SalesOrderId;
END


CREATE OR ALTER PROCEDURE sales.SP_Add_Sales_Order_Item
    @SalesOrderId INT,
    @ProductId INT,
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2)
AS
BEGIN
    INSERT INTO sales.SalesOrderDetail
        (SalesOrderId, ProductId, Quantity, UnitPrice,
         CreatedDate, CreatedBy)
    VALUES
        (@SalesOrderId, @ProductId, @Quantity, @UnitPrice,
         GETDATE(), 'system');

    UPDATE sales.SalesOrderHeader
    SET TotalAmount = (
        SELECT SUM(Quantity * UnitPrice) FROM sales.SalesOrderDetail
        WHERE SalesOrderId = @SalesOrderId
    )
    WHERE SalesOrderId = @SalesOrderId;
END


CREATE PROCEDURE sales.SP_Update_Sales_Order_Status
    @SalesOrderId INT,
    @OrderStatus VARCHAR(50)
AS
BEGIN
    UPDATE sales.SalesOrderHeader
    SET OrderStatus = @OrderStatus
    WHERE SalesOrderId = @SalesOrderId;
END


CREATE PROCEDURE report.SP_Inventory_Summary
AS
BEGIN
    SELECT p.ProductCode, p.ProductName,
           w.WarehouseName,
           i.Quantity, i.ReorderLevel,
           CASE WHEN i.Quantity <= i.ReorderLevel
                THEN 'Low Stock' ELSE 'OK' END AS StockStatus
    FROM inventory.Inventory i
    JOIN master.Product p ON i.ProductId = p.ProductID
    JOIN inventory.Warehouse w ON i.WarehouseId = w.WarehouseId
    ORDER BY StockStatus DESC, p.ProductName;
END


CREATE PROCEDURE report.SP_Sales_Summary
AS
BEGIN
    SELECT c.CustomerName,
           COUNT(h.SalesOrderId) AS TotalOrders,
           SUM(h.TotalAmount) AS TotalRevenue
    FROM sales.SalesOrderHeader h
    JOIN sales.Customer c ON h.CustomerId = c.CustomerId
    GROUP BY c.CustomerName
    ORDER BY TotalRevenue DESC;
END


CREATE PROCEDURE report.SP_Purchase_Summary
AS
BEGIN
    SELECT s.SupplierName,
           COUNT(h.PurchaseOrderID) AS TotalOrders,
           SUM(h.TotalAmount) AS TotalSpend
    FROM purchase.PurchaseOrderHeader h
    JOIN master.Supplier s ON h.SupplierID = s.SupplierID
    GROUP BY s.SupplierName
    ORDER BY TotalSpend DESC;
END



SELECT ROUTINE_SCHEMA, ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
AND ROUTINE_NAME LIKE 'SP_%Sales%'
   OR ROUTINE_NAME LIKE 'SP_%Inventory_Summary%'
   OR ROUTINE_NAME LIKE 'SP_%Purchase_Summary%'
ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME;


SELECT 'Category' AS TableName, CategoryID AS ID, CategoryName AS Name FROM master.Category WHERE IsActive = 1
UNION ALL
SELECT 'Brand', BrandID, BrandName FROM master.Brand WHERE IsActive = 1
UNION ALL
SELECT 'Unit', UnitID, UnitName FROM master.Unit WHERE IsActive = 1
UNION ALL
SELECT 'Tax', TaxID, TaxName FROM master.Tax WHERE IsActive = 1
UNION ALL
SELECT 'Currency', CurrencyID, CurrencyName FROM master.Currency WHERE IsActive = 1;