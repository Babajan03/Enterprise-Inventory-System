USE InventoryManagementDB;
GO

IF OBJECT_ID('master.StockTransfer', 'U') IS NOT NULL
BEGIN
    DROP TABLE master.StockTransfer;
END
GO

CREATE TABLE master.StockTransfer (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    TransferNumber AS ('TRN' + RIGHT('000000' + CAST(TransferID AS VARCHAR(10)), 6)) PERSISTED,
    ProductID INT NOT NULL,
    FromWarehouseID INT NOT NULL,
    ToWarehouseID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    TransferDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Completed, Cancelled
    RequestedBy INT NULL,
    Notes NVARCHAR(255) NULL,
    CONSTRAINT FK_StockTransfer_Product FOREIGN KEY (ProductID) REFERENCES master.Product(ProductID),
    CONSTRAINT FK_StockTransfer_FromWarehouse FOREIGN KEY (FromWarehouseID) REFERENCES inventory.Warehouse(WarehouseId),
    CONSTRAINT FK_StockTransfer_ToWarehouse FOREIGN KEY (ToWarehouseID) REFERENCES inventory.Warehouse(WarehouseId),
    CONSTRAINT FK_StockTransfer_User FOREIGN KEY (RequestedBy) REFERENCES master.[User](UserID)
);
GO


SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StockTransfer';
EXEC sp_help 'master.StockTransfer';