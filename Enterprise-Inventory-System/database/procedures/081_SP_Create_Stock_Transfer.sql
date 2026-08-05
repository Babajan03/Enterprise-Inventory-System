USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Create_Stock_Transfer
    @ProductID INT,
    @FromWarehouseID INT,
    @ToWarehouseID INT,
    @Quantity INT,
    @RequestedBy INT,
    @Notes NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if sufficient stock exists
    DECLARE @Available INT = 0;
    SELECT @Available = Quantity FROM inventory.Inventory 
    WHERE ProductID = @ProductID AND WarehouseId = @FromWarehouseID;

    IF @Available < @Quantity
    BEGIN
        RAISERROR('Insufficient stock in the source warehouse.', 16, 1);
        RETURN;
    END

    INSERT INTO master.StockTransfer (ProductID, FromWarehouseID, ToWarehouseID, Quantity, RequestedBy, Notes)
    VALUES (@ProductID, @FromWarehouseID, @ToWarehouseID, @Quantity, @RequestedBy, @Notes);
END;
GO
