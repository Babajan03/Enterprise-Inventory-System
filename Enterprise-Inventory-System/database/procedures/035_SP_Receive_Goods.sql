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