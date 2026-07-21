USE InventoryManagementDB;
GO


CREATE TABLE audit.InventoryAudit
(
    AuditId INT IDENTITY(1,1)
        CONSTRAINT PK_InventoryAudit PRIMARY KEY,


    InventoryId INT NOT NULL,


    OldQuantity DECIMAL(18,2),


    NewQuantity DECIMAL(18,2),


    Difference AS
    (
        NewQuantity - OldQuantity
    ),


    ChangedBy VARCHAR(100),


    ChangedDate DATETIME2
        DEFAULT SYSDATETIME()

);
GO



CREATE OR ALTER TRIGGER inventory.TR_Inventory_Audit
ON inventory.Inventory
AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;



INSERT INTO audit.InventoryAudit
(
    InventoryId,
    OldQuantity,
    NewQuantity,
    ChangedBy
)

SELECT

    D.InventoryId,

    D.Quantity,

    I.Quantity,

    SYSTEM_USER


FROM deleted D

INNER JOIN inserted I

ON D.InventoryId = I.InventoryId;



END;
GO


SELECT *
FROM inventory.Inventory;


UPDATE inventory.Inventory
SET Quantity = Quantity + 5
WHERE InventoryId = 1;


SELECT *
FROM audit.InventoryAudit;