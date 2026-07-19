USE InventoryManagementDB;
GO

/*
    Script Name : 032_Create_Inventory_Table.sql
    Purpose     : Create inventory stock table
    Module      : Inventory Management
*/


CREATE TABLE inventory.Inventory
(
    InventoryId INT IDENTITY(1,1)
        CONSTRAINT PK_Inventory PRIMARY KEY,

    WarehouseId INT NOT NULL,

    ProductId INT NOT NULL,

    Quantity DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Inventory_Quantity DEFAULT 0,

    ReorderLevel DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Inventory_ReorderLevel DEFAULT 0,

    LastUpdatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Inventory_LastUpdatedDate DEFAULT SYSDATETIME(),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Inventory_CreatedDate DEFAULT SYSDATETIME(),

    CreatedBy VARCHAR(50) NOT NULL,

    ModifiedDate DATETIME2 NULL,

    ModifiedBy VARCHAR(50) NULL,


    CONSTRAINT FK_Inventory_Warehouse
    FOREIGN KEY (WarehouseId)
    REFERENCES inventory.Warehouse(WarehouseId)
);
GO