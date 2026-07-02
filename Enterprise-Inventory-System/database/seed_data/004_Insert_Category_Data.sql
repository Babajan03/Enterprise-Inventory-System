USE InventoryManagementDB;
GO

INSERT INTO master.Category
(
    CategoryCode,
    CategoryName,
    Description
)
VALUES
('CAT001', 'Laptop', 'Laptop Computers'),
('CAT002', 'Desktop', 'Desktop Computers'),
('CAT003', 'Monitor', 'Computer Monitors'),
('CAT004', 'Keyboard', 'Computer Keyboards'),
('CAT005', 'Mouse', 'Computer Mouse'),
('CAT006', 'Printer', 'Printers'),
('CAT007', 'Networking', 'Networking Equipment'),
('CAT008', 'Storage', 'Storage Devices'),
('CAT009', 'Accessories', 'Computer Accessories'),
('CAT010', 'Software', 'Software Products');
GO


SELECT *
FROM master.Category;