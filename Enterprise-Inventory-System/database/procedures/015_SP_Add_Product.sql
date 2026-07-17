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




EXEC master.SP_Add_Product

@ProductCode='PRD0011',

@ProductName='Lenovo ThinkPad',

@ProductDescription='Business Laptop',

@SKU='SKU0011',

@Barcode='890100000011',

@HSNCode='847130',

@CategoryID=1,

@BrandID=1,

@UnitID=1,

@TaxID=4,

@CurrencyID=1,

@CostPrice=55000,

@SellingPrice=62000,

@MinimumStock=5,

@MaximumStock=100,

@ReorderLevel=10;





SELECT *
FROM master.Product
WHERE ProductCode='PRD0011';