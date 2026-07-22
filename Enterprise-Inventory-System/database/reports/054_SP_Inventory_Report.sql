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