/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Purchase Management
Object Name  : SP_Create_Purchase_Order
Script Name  : 027_SP_Create_Purchase_Order.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE purchase.SP_Create_Purchase_Order

    @SupplierID INT,
    @ExpectedDeliveryDate DATE = NULL,
    @Remarks NVARCHAR(500) = NULL

AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @PurchaseOrderID INT;
    DECLARE @PurchaseOrderNumber VARCHAR(30);

    BEGIN TRY

        BEGIN TRANSACTION;

        --------------------------------------------------------
        -- Validate Supplier
        --------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM master.Supplier
            WHERE SupplierID = @SupplierID
              AND IsActive = 1
        )
        BEGIN
            RAISERROR('Supplier does not exist or is inactive.',16,1);
        END

        --------------------------------------------------------
        -- Generate PO Number
        --------------------------------------------------------

        SET @PurchaseOrderNumber =
            'PO' +
            CONVERT(VARCHAR(8), GETDATE(), 112) +
            RIGHT('0000' + CAST(
                ISNULL(
                    (SELECT COUNT(*) + 1
                     FROM purchase.PurchaseOrderHeader),
                1) AS VARCHAR(4)),4);

        --------------------------------------------------------
        -- Insert Header
        --------------------------------------------------------

        INSERT INTO purchase.PurchaseOrderHeader
        (
            PurchaseOrderNumber,
            SupplierID,
            OrderDate,
            ExpectedDeliveryDate,
            Remarks
        )
        VALUES
        (
            @PurchaseOrderNumber,
            @SupplierID,
            CAST(GETDATE() AS DATE),
            @ExpectedDeliveryDate,
            @Remarks
        );

        SET @PurchaseOrderID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT

            'Success' AS Status,

            @PurchaseOrderID AS PurchaseOrderID,

            @PurchaseOrderNumber AS PurchaseOrderNumber,

            'Purchase Order created successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT

            'Failed' AS Status,

            ERROR_MESSAGE() AS ErrorMessage,

            ERROR_NUMBER() AS ErrorNumber,

            ERROR_LINE() AS ErrorLine;

    END CATCH

END
GO



EXEC purchase.SP_Create_Purchase_Order

    @SupplierID = 1,

    @ExpectedDeliveryDate = '2026-07-15',

    @Remarks = 'Initial inventory purchase';



SELECT *
FROM purchase.PurchaseOrderHeader;