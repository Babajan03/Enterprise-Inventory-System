USE InventoryManagementDB;
GO

INSERT INTO master.Brand
(
    BrandCode,
    BrandName,
    Description
)
VALUES
('BR001','Dell','Dell Technologies'),
('BR002','HP','HP Inc.'),
('BR003','Lenovo','Lenovo Group'),
('BR004','Apple','Apple Inc.'),
('BR005','Samsung','Samsung Electronics'),
('BR006','Acer','Acer Inc.'),
('BR007','Asus','ASUS'),
('BR008','MSI','Micro-Star International'),
('BR009','LG','LG Electronics'),
('BR010','Logitech','Logitech');
GO


SELECT *
FROM master.Brand
ORDER BY BrandName;