USE InventoryManagementDB;
GO


PRINT 'Creating missing performance indexes...';


------------------------------------------------
-- Inventory
------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Inventory_Product_Warehouse'
    AND object_id = OBJECT_ID('inventory.Inventory')
)
BEGIN

CREATE INDEX IX_Inventory_Product_Warehouse
ON inventory.Inventory
(
    ProductId,
    WarehouseId
);

END;



IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Inventory_Quantity'
    AND object_id = OBJECT_ID('inventory.Inventory')
)
BEGIN

CREATE INDEX IX_Inventory_Quantity
ON inventory.Inventory
(
    Quantity
);

END;



------------------------------------------------
-- Inventory Transaction
------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_InventoryTransaction_Date'
    AND object_id = OBJECT_ID('inventory.InventoryTransaction')
)
BEGIN

CREATE INDEX IX_InventoryTransaction_Date
ON inventory.InventoryTransaction
(
    TransactionDate
);

END;



IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_InventoryTransaction_Type'
    AND object_id = OBJECT_ID('inventory.InventoryTransaction')
)
BEGIN

CREATE INDEX IX_InventoryTransaction_Type
ON inventory.InventoryTransaction
(
    TransactionType
);

END;



------------------------------------------------
-- Sales
------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SalesOrderHeader_Date'
    AND object_id = OBJECT_ID('sales.SalesOrderHeader')
)
BEGIN

CREATE INDEX IX_SalesOrderHeader_Date
ON sales.SalesOrderHeader
(
    OrderDate
);

END;



IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SalesOrderHeader_Status'
    AND object_id = OBJECT_ID('sales.SalesOrderHeader')
)
BEGIN

CREATE INDEX IX_SalesOrderHeader_Status
ON sales.SalesOrderHeader
(
    OrderStatus
);

END;



IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SalesOrderDetail_Product'
    AND object_id = OBJECT_ID('sales.SalesOrderDetail')
)
BEGIN

CREATE INDEX IX_SalesOrderDetail_Product
ON sales.SalesOrderDetail
(
    ProductId
);

END;



------------------------------------------------
-- Purchase
------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PurchaseOrderHeader_Date'
    AND object_id = OBJECT_ID('purchase.PurchaseOrderHeader')
)
BEGIN

CREATE INDEX IX_PurchaseOrderHeader_Date
ON purchase.PurchaseOrderHeader
(
    OrderDate
);

END;



IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PurchaseOrderDetail_Product'
    AND object_id = OBJECT_ID('purchase.PurchaseOrderDetail')
)
BEGIN

CREATE INDEX IX_PurchaseOrderDetail_Product
ON purchase.PurchaseOrderDetail
(
    ProductID
);

END;


PRINT 'Performance indexes completed successfully';

GO