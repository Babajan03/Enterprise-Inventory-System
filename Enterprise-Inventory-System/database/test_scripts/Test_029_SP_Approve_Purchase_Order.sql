-------------------------------------------------------
-- Test 1 : Approve Purchase Order
-------------------------------------------------------

EXEC purchase.SP_Approve_Purchase_Order
    @PurchaseOrderID = 1;

-------------------------------------------------------
-- Verify
-------------------------------------------------------

SELECT
    PurchaseOrderNumber,
    Status,
    TotalAmount,
    ModifiedDate,
    ModifiedBy
FROM purchase.PurchaseOrderHeader
WHERE PurchaseOrderID = 1;