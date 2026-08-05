USE InventoryManagementDB;
GO

-- Add approval tracking columns to PurchaseOrderHeader
IF COL_LENGTH('purchase.PurchaseOrderHeader', 'ApprovedBy') IS NULL
BEGIN
    ALTER TABLE purchase.PurchaseOrderHeader
        ADD ApprovedBy INT NULL,
            ApprovalDate DATETIME2 NULL;
END
GO

-- Add foreign key for ApprovedBy referencing master.[User]
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_PurchaseOrder_ApprovedBy'
)
BEGIN
    ALTER TABLE purchase.PurchaseOrderHeader
        ADD CONSTRAINT FK_PurchaseOrder_ApprovedBy FOREIGN KEY (ApprovedBy)
        REFERENCES master.[User](UserID);
END
GO
