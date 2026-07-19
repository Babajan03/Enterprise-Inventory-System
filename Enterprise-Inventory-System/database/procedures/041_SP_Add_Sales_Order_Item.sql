USE InventoryManagementDB;
GO

/*
    Stored Procedure
    Purpose:
    Add item into Sales Order
*/


CREATE OR ALTER PROCEDURE sales.SP_Add_Sales_Order_Item
(
    @SalesOrderId INT,
    @ProductId INT,
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @CreatedBy VARCHAR(50)
)
AS
BEGIN

    SET NOCOUNT ON;


    BEGIN TRANSACTION;

    BEGIN TRY


        INSERT INTO sales.SalesOrderDetail
        (
            SalesOrderId,
            ProductId,
            Quantity,
            UnitPrice,
            CreatedBy
        )
        VALUES
        (
            @SalesOrderId,
            @ProductId,
            @Quantity,
            @UnitPrice,
            @CreatedBy
        );


        UPDATE sales.SalesOrderHeader
        SET
            TotalAmount =
            (
                SELECT SUM(Quantity * UnitPrice)
                FROM sales.SalesOrderDetail
                WHERE SalesOrderId = @SalesOrderId
            )
        WHERE SalesOrderId = @SalesOrderId;



        COMMIT TRANSACTION;


    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH

END;
GO