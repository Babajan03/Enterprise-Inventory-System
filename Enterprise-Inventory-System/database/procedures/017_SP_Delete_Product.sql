/*
==============================================================================
Project      : Enterprise Inventory Management System (EIMS)
Module       : Product Management
Object Name  : SP_Delete_Product
Script Name  : 017_SP_Delete_Product.sql
Author       : Shaik Babajan
Version      : 1.0
==============================================================================
*/

USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Delete_Product

      @ProductID INT

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

IsActive=0,
ModifiedDate=SYSDATETIME(),
ModifiedBy=SUSER_SNAME()

WHERE ProductID=@ProductID;

COMMIT TRANSACTION;

SELECT
'Success' AS Status,
'Product deleted successfully (Soft Delete).' AS Message;

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



EXEC master.SP_Delete_Product

@ProductID=1;



SELECT
ProductID,
ProductName,
IsActive
FROM master.Product
WHERE ProductID=1;