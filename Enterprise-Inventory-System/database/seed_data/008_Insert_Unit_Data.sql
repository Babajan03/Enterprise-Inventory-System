USE InventoryManagementDB;
GO

INSERT INTO master.Unit
(
    UnitCode,
    UnitName,
    UnitSymbol,
    Description
)
VALUES
('UNT001', 'Piece', 'PCS', 'Individual item'),
('UNT002', 'Kilogram', 'KG', 'Weight in kilograms'),
('UNT003', 'Gram', 'GM', 'Weight in grams'),
('UNT004', 'Liter', 'L', 'Volume in liters'),
('UNT005', 'Milliliter', 'ML', 'Volume in milliliters'),
('UNT006', 'Meter', 'M', 'Length in meters'),
('UNT007', 'Centimeter', 'CM', 'Length in centimeters'),
('UNT008', 'Box', 'BOX', 'Box packaging'),
('UNT009', 'Pack', 'PK', 'Pack of items'),
('UNT010', 'Dozen', 'DOZ', 'Twelve items');
GO