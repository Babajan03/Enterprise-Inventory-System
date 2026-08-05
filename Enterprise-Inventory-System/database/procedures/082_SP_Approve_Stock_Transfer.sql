USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Approve_Stock_Transfer
    @TransferID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Status NVARCHAR(20), @ProductID INT, @FromWarehouseID INT, @ToWarehouseID INT, @Quantity INT;
    
    SELECT @Status = Status, @ProductID = ProductID, @FromWarehouseID = FromWarehouseID, 
           @ToWarehouseID = ToWarehouseID, @Quantity = Quantity
    FROM master.StockTransfer
    WHERE TransferID = @TransferID;

    IF @Status != 'Pending'
    BEGIN
        RAISERROR('Only pending transfers can be approved.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Deduct from source
        UPDATE inventory.Inventory 
        SET Quantity = Quantity - @Quantity, LastUpdatedDate = GETDATE()
        WHERE ProductID = @ProductID AND WarehouseId = @FromWarehouseID;

        -- Add to destination (create if not exists)
        IF EXISTS (SELECT 1 FROM inventory.Inventory WHERE ProductID = @ProductID AND WarehouseId = @ToWarehouseID)
        BEGIN
            UPDATE inventory.Inventory 
            SET Quantity = Quantity + @Quantity, LastUpdatedDate = GETDATE()
            WHERE ProductID = @ProductID AND WarehouseId = @ToWarehouseID;
        END
        ELSE
        BEGIN
            INSERT INTO inventory.Inventory (ProductID, WarehouseId, Quantity, ReorderLevel)
            VALUES (@ProductID, @ToWarehouseID, @Quantity, 10);
        END

        -- Mark transfer completed
        UPDATE master.StockTransfer
        SET Status = 'Completed'
        WHERE TransferID = @TransferID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
