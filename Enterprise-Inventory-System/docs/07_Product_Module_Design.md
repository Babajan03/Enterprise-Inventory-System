# Product Module Design

## Purpose

The Product table stores all inventory items sold or purchased by the organization.

---

## Master Tables Used

- Category
- Brand
- Unit
- Tax
- Currency

---

## Relationships

Category (1) ------< Product

Brand (1) ---------< Product

Unit (1) ----------< Product

Tax (1) -----------< Product

Currency (1) ------< Product

---

## Business Rules

- Every product belongs to one category.
- Every product belongs to one brand.
- Every product has one unit.
- Every product has one tax configuration.
- Every product has one base currency.
- Product Code must be unique.
- Product Name must be unique.
- Selling Price cannot be negative.
- Cost Price cannot be negative.
- Selling Price should normally be greater than or equal to Cost Price.
- Products are never physically deleted. They are deactivated using IsActive.

---

## Future Modules Depending on Product

- Purchase Order
- Sales Order
- Inventory
- Stock Movement
- Supplier Mapping
- Price History