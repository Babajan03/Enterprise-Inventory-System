/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Purchase Management
Object Name  : SP_Add_Purchase_Order_Item
Script Name  : 028_SP_Add_Purchase_Order_Item.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE purchase.SP_Add_Purchase_Order_Item

    @PurchaseOrderID INT,
    @ProductID INT,
    @OrderedQuantity DECIMAL(18,2)

AS
BEGIN

SET NOCOUNT ON;

DECLARE @SupplierID INT;
DECLARE @UnitPrice DECIMAL(18,2);
DECLARE @TaxAmount DECIMAL(18,2)=0;
DECLARE @DiscountAmount DECIMAL(18,2)=0;
DECLARE @LineTotal DECIMAL(18,2);

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
      AND Status='Draft'
)
BEGIN
    RAISERROR('Purchase Order not found or not in Draft status.',16,1);
END

--------------------------------------------------------
-- Validate Product
--------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM master.Product
    WHERE ProductID=@ProductID
      AND IsActive=1
)
BEGIN
    RAISERROR('Product not found or inactive.',16,1);
END

--------------------------------------------------------
-- Get Supplier
--------------------------------------------------------

SELECT @SupplierID = SupplierID
FROM purchase.PurchaseOrderHeader
WHERE PurchaseOrderID=@PurchaseOrderID;

--------------------------------------------------------
-- Get Purchase Price
--------------------------------------------------------

SELECT TOP (1)
       @UnitPrice = PurchasePrice
FROM master.ProductSupplier
WHERE ProductID=@ProductID
  AND SupplierID=@SupplierID
  AND IsActive=1
ORDER BY IsPreferredSupplier DESC;

IF @UnitPrice IS NULL
BEGIN
    RAISERROR('Selected supplier cannot supply this product.',16,1);
END

--------------------------------------------------------
-- Calculate Line Total
--------------------------------------------------------

SET @LineTotal =
(@OrderedQuantity*@UnitPrice)
- @DiscountAmount
+ @TaxAmount;

--------------------------------------------------------
-- Insert Detail
--------------------------------------------------------

INSERT INTO purchase.PurchaseOrderDetail
(
PurchaseOrderID,
ProductID,
OrderedQuantity,
UnitPrice,
DiscountAmount,
TaxAmount,
LineTotal
)

VALUES
(
@PurchaseOrderID,
@ProductID,
@OrderedQuantity,
@UnitPrice,
@DiscountAmount,
@TaxAmount,
@LineTotal
);

--------------------------------------------------------
-- Update Header Total
--------------------------------------------------------

UPDATE purchase.PurchaseOrderHeader

SET

TotalAmount =
(
SELECT SUM(LineTotal)
FROM purchase.PurchaseOrderDetail
WHERE PurchaseOrderID=@PurchaseOrderID
),

ModifiedDate=SYSDATETIME(),
ModifiedBy=SUSER_SNAME()

WHERE PurchaseOrderID=@PurchaseOrderID;

COMMIT TRANSACTION;

SELECT

'Success' AS Status,

'Purchase Order Item Added Successfully.' AS Message;

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