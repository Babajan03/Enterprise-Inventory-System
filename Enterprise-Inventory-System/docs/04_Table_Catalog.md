# Table Catalog

## Master Tables

| Table | Description |
|---------|------------|
| Category | Product Categories |
| Brand | Product Brands |
| Unit | Product Units |
| Product | Product Information |
| Supplier | Supplier Information |
| Warehouse | Warehouse Information |
| Customer | Customer Information |
| Employee | Employee Information |

---

## Transaction Tables

| Table | Description |
|---------|------------|
| PurchaseOrder | Purchase Order Header |
| PurchaseOrderItem | Purchase Order Line Items |
| GoodsReceipt | Goods Received From Supplier |
| SalesOrder | Sales Order Header |
| SalesOrderItem | Sales Order Line Items |
| Inventory | Current Stock |
| InventoryMovement | Every Inventory Movement |
| StockTransfer | Warehouse Transfers |

---

## Audit Tables

| Table | Description |
|---------|------------|
| AuditLog | Tracks Database Changes |

---

## Reference Tables

| Table | Description |
|---------|------------|
| OrderStatus | Purchase/Sales Status |
| PaymentStatus | Payment Status |
| ProductStatus | Active / Inactive |