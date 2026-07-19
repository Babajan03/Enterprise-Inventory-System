USE InventoryManagementDB;
GO

/*
    Script Name : 034_Create_InventoryTransaction_Table.sql
    Purpose     : Track all inventory movements
*/


CREATE TABLE inventory.InventoryTransaction
(
    TransactionId INT IDENTITY(1,1)
        CONSTRAINT PK_InventoryTransaction PRIMARY KEY,


    InventoryId INT NOT NULL,


    TransactionType VARCHAR(30) NOT NULL,


    Quantity DECIMAL(18,2) NOT NULL,


    TransactionDate DATETIME2 NOT NULL
        CONSTRAINT DF_InventoryTransaction_Date
        DEFAULT SYSDATETIME(),


    ReferenceNumber VARCHAR(50) NULL,


    Remarks VARCHAR(250) NULL,


    CreatedBy VARCHAR(50) NOT NULL,


    CONSTRAINT FK_InventoryTransaction_Inventory
    FOREIGN KEY (InventoryId)
    REFERENCES inventory.Inventory(InventoryId)
);
GO