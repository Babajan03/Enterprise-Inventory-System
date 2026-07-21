USE InventoryManagementDB;
GO


CREATE TABLE audit.ProductAudit
(
    AuditId INT IDENTITY(1,1)
        CONSTRAINT PK_ProductAudit PRIMARY KEY,


    ProductId INT NOT NULL,


    ActionType VARCHAR(20) NOT NULL,


    OldProductName VARCHAR(150) NULL,


    NewProductName VARCHAR(150) NULL,


    OldSellingPrice DECIMAL(18,2) NULL,


    NewSellingPrice DECIMAL(18,2) NULL,


    ChangedBy VARCHAR(100),


    ChangedDate DATETIME2
        DEFAULT SYSDATETIME()

);
GO



CREATE OR ALTER TRIGGER master.TR_Product_Audit
ON master.Product
AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;


INSERT INTO audit.ProductAudit
(
    ProductId,
    ActionType,
    OldProductName,
    NewProductName,
    OldSellingPrice,
    NewSellingPrice,
    ChangedBy
)

SELECT

    D.ProductID,

    'UPDATE',

    D.ProductName,

    I.ProductName,

    D.SellingPrice,

    I.SellingPrice,

    SYSTEM_USER


FROM deleted D

INNER JOIN inserted I

ON D.ProductID = I.ProductID;


END;
GO



SELECT *
FROM master.Product;


UPDATE master.Product
SET SellingPrice = 56000
WHERE ProductID = 1;


SELECT *
FROM audit.ProductAudit;