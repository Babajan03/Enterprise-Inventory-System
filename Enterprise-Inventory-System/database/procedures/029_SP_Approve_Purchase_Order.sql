/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Purchase Management
Object Name  : SP_Approve_Purchase_Order
Script Name  : 029_SP_Approve_Purchase_Order.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE purchase.SP_Approve_Purchase_Order

    @PurchaseOrderID INT

AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;

--------------------------------------------------------
-- Validate Purchase Order
--------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM purchase.PurchaseOrderHeader
    WHERE PurchaseOrderID=@PurchaseOrderID
)
BEGIN
    RAISERROR('Purchase Order not found.',16,1);
END

--------------------------------------------------------
-- Validate Status
--------------------------------------------------------

IF EXISTS
(
    SELECT 1
    FROM purchase.PurchaseOrderHeader
    WHERE PurchaseOrderID=@PurchaseOrderID
      AND Status<>'Draft'
)
BEGIN
    RAISERROR('Only Draft Purchase Orders can be approved.',16,1);
END

--------------------------------------------------------
-- Validate Items Exist
--------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM purchase.PurchaseOrderDetail
    WHERE PurchaseOrderID=@PurchaseOrderID
)
BEGIN
    RAISERROR('Purchase Order contains no items.',16,1);
END

--------------------------------------------------------
-- Approve Purchase Order
--------------------------------------------------------

UPDATE purchase.PurchaseOrderHeader

SET

Status='Approved',

ModifiedDate=SYSDATETIME(),

ModifiedBy=SUSER_SNAME()

WHERE PurchaseOrderID=@PurchaseOrderID;

COMMIT TRANSACTION;

SELECT

'Success' AS Status,

'Purchase Order approved successfully.' AS Message;

END TRY

BEGIN CATCH

IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;

SELECT

'Failed' AS Status,

ERROR_MESSAGE() AS ErrorMessage,

ERROR_NUMBER() AS ErrorNumber,

ERROR_LINE() AS ErrorLine;

END CATCH

END
GO