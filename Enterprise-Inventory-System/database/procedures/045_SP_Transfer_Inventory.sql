USE InventoryManagementDB;
GO


CREATE OR ALTER PROCEDURE inventory.SP_Transfer_Inventory
(
    @FromInventoryId INT,
    @ToInventoryId INT,
    @Quantity DECIMAL(18,2),
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRANSACTION;


BEGIN TRY


DECLARE @AvailableQty DECIMAL(18,2);


SELECT 
@AvailableQty = Quantity
FROM inventory.Inventory
WHERE InventoryId = @FromInventoryId;



IF @AvailableQty < @Quantity
BEGIN

    THROW 50002,
    'Insufficient Stock For Transfer',
    1;

END



UPDATE inventory.Inventory
SET
    Quantity = Quantity - @Quantity,
    LastUpdatedDate = SYSDATETIME(),
    ModifiedBy = @CreatedBy,
    ModifiedDate = SYSDATETIME()

WHERE InventoryId = @FromInventoryId;



UPDATE inventory.Inventory
SET
    Quantity = Quantity + @Quantity,
    LastUpdatedDate = SYSDATETIME(),
    ModifiedBy = @CreatedBy,
    ModifiedDate = SYSDATETIME()

WHERE InventoryId = @ToInventoryId;



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
    @FromInventoryId,
    'TRANSFER_OUT',
    @Quantity,
    'Inventory Transfer Out',
    @CreatedBy
),
(
    @ToInventoryId,
    'TRANSFER_IN',
    @Quantity,
    'Inventory Transfer In',
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