USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE inventory.SP_Adjust_Inventory
(
    @InventoryId INT,
    @AdjustmentQuantity DECIMAL(18,2),
    @Reason VARCHAR(250),
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

    SET NOCOUNT ON;


    BEGIN TRANSACTION;


    BEGIN TRY


        UPDATE inventory.Inventory
        SET
            Quantity = Quantity + @AdjustmentQuantity,
            LastUpdatedDate = SYSDATETIME(),
            ModifiedDate = SYSDATETIME(),
            ModifiedBy = @CreatedBy

        WHERE InventoryId = @InventoryId;



        INSERT INTO inventory.InventoryTransaction
        (
            InventoryId,
            TransactionType,
            Quantity,
            Remarks,
            CreatedBy
        )
        VALUES
        (
            @InventoryId,
            'STOCK_ADJUSTMENT',
            @AdjustmentQuantity,
            @Reason,
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