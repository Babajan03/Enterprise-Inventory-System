/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Update_Product
Script Name  : 016_SP_Update_Product.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Update_Product

      @ProductID INT,
      @ProductName NVARCHAR(200),
      @ProductDescription NVARCHAR(500)=NULL,
      @SKU VARCHAR(50)=NULL,
      @Barcode VARCHAR(100)=NULL,
      @HSNCode VARCHAR(20)=NULL,
      @CategoryID INT,
      @BrandID INT,
      @UnitID INT,
      @TaxID INT,
      @CurrencyID INT,
      @CostPrice DECIMAL(18,2),
      @SellingPrice DECIMAL(18,2),
      @MinimumStock INT,
      @MaximumStock INT,
      @ReorderLevel INT

AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;

IF NOT EXISTS
(
    SELECT 1
    FROM master.Product
    WHERE ProductID=@ProductID
)
BEGIN
    RAISERROR('Product not found.',16,1);
END

UPDATE master.Product

SET

ProductName=@ProductName,
ProductDescription=@ProductDescription,
SKU=@SKU,
Barcode=@Barcode,
HSNCode=@HSNCode,
CategoryID=@CategoryID,
BrandID=@BrandID,
UnitID=@UnitID,
TaxID=@TaxID,
CurrencyID=@CurrencyID,
CostPrice=@CostPrice,
SellingPrice=@SellingPrice,
MinimumStock=@MinimumStock,
MaximumStock=@MaximumStock,
ReorderLevel=@ReorderLevel,
ModifiedDate=SYSDATETIME(),
ModifiedBy=SUSER_SNAME()

WHERE ProductID=@ProductID;

COMMIT TRANSACTION;

SELECT
'Success' AS Status,
'Product Updated Successfully' AS Message;

END TRY

BEGIN CATCH

IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;

SELECT
'Failed' AS Status,
ERROR_MESSAGE() AS ErrorMessage;

END CATCH

END
GO



EXEC master.SP_Update_Product

@ProductID=1,
@ProductName='Dell Inspiron 15 Gen 2',
@ProductDescription='Updated Laptop',
@SKU='SKU0001',
@Barcode='890100000001',
@HSNCode='847130',
@CategoryID=1,
@BrandID=1,
@UnitID=1,
@TaxID=4,
@CurrencyID=1,
@CostPrice=47000,
@SellingPrice=55000,
@MinimumStock=5,
@MaximumStock=100,
@ReorderLevel=10;



SELECT *
FROM master.Product
WHERE ProductID=1;