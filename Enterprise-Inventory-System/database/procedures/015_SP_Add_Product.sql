/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Add_Product
Script Name  : 015_SP_Add_Product.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Add_Product

      @ProductCode        VARCHAR(30),
      @ProductName        NVARCHAR(200),
      @ProductDescription NVARCHAR(500)=NULL,
      @SKU                VARCHAR(50)=NULL,
      @Barcode            VARCHAR(100)=NULL,
      @HSNCode            VARCHAR(20)=NULL,

      @CategoryID         INT,
      @BrandID            INT,
      @UnitID             INT,
      @TaxID              INT,
      @CurrencyID         INT,

      @CostPrice          DECIMAL(18,2),
      @SellingPrice       DECIMAL(18,2),

      @MinimumStock       INT=0,
      @MaximumStock       INT=1000,
      @ReorderLevel       INT=10

AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;

-------------------------------------------------------
-- Validation
-------------------------------------------------------

IF EXISTS
(
    SELECT 1
    FROM master.Product
    WHERE ProductCode=@ProductCode
)
BEGIN
    RAISERROR('Product Code already exists.',16,1);
END

IF EXISTS
(
    SELECT 1
    FROM master.Product
    WHERE ProductName=@ProductName
)
BEGIN
    RAISERROR('Product Name already exists.',16,1);
END

-------------------------------------------------------
-- Insert
-------------------------------------------------------

INSERT INTO master.Product
(
ProductCode,
ProductName,
ProductDescription,
SKU,
Barcode,
HSNCode,
CategoryID,
BrandID,
UnitID,
TaxID,
CurrencyID,
CostPrice,
SellingPrice,
MinimumStock,
MaximumStock,
ReorderLevel
)

VALUES
(
@ProductCode,
@ProductName,
@ProductDescription,
@SKU,
@Barcode,
@HSNCode,
@CategoryID,
@BrandID,
@UnitID,
@TaxID,
@CurrencyID,
@CostPrice,
@SellingPrice,
@MinimumStock,
@MaximumStock,
@ReorderLevel
);

COMMIT TRANSACTION;

SELECT
'Success' AS Status,
'Product Created Successfully' AS Message;

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