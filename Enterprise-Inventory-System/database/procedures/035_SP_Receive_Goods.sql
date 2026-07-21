USE InventoryManagementDB;
GO

/*
    Stored Procedure
    Purpose:
    Receive goods and increase inventory quantity
*/


CREATE OR ALTER PROCEDURE inventory.SP_Receive_Goods
(
    @InventoryId INT,
    @Quantity DECIMAL(18,2),
    @ReferenceNumber VARCHAR(50),
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

    SET NOCOUNT ON;


    BEGIN TRANSACTION;


    BEGIN TRY


        UPDATE inventory.Inventory
        SET
            Quantity = Quantity + @Quantity,
            LastUpdatedDate = SYSDATETIME(),
            ModifiedDate = SYSDATETIME(),
            ModifiedBy = @CreatedBy

        WHERE InventoryId = @InventoryId;



        INSERT INTO inventory.InventoryTransaction
        (
            InventoryId,
            TransactionType,
            Quantity,
            ReferenceNumber,
            CreatedBy
        )
        VALUES
        (
            @InventoryId,
            'GOODS_RECEIVED',
            @Quantity,
            @ReferenceNumber,
            @CreatedBy
        );


        COMMIT TRANSACTION;


    END TRY


    BEGIN CATCH

        ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO



EXEC inventory.SP_Receive_Goods
    @InventoryId = 1,
    @Quantity = 50,
    @ReferenceNumber = 'GRN001',
    @CreatedBy = 'SYSTEM';


    SELECT *
FROM inventory.Inventory;

SELECT *
FROM inventory.InventoryTransaction;


USE InventoryManagementDB;
GO

SELECT *
FROM master.Product;

SELECT *
FROM inventory.Warehouse;



USE InventoryManagementDB;
GO

SELECT
    I.InventoryId,
    W.WarehouseName,
    P.ProductName,
    I.Quantity,
    I.ReorderLevel
FROM inventory.Inventory I
INNER JOIN inventory.Warehouse W
    ON I.WarehouseId = W.WarehouseId
INNER JOIN master.Product P
    ON I.ProductId = P.ProductID;