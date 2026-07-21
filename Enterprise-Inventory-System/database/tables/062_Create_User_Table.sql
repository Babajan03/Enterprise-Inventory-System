USE InventoryManagementDB;
GO
CREATE TABLE master.[User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    Role NVARCHAR(30) NOT NULL DEFAULT 'Staff',
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

USE InventoryManagementDB;
GO
EXEC master.SP_Get_All_Suppliers


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Supplier'
ORDER BY ORDINAL_POSITION;

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Supplier'
ORDER BY TABLE_SCHEMA, ORDINAL_POSITION;


CREATE PROCEDURE master.SP_Get_All_Suppliers
AS
BEGIN
    SELECT SupplierID, SupplierCode, SupplierName, ContactPerson,
           Email, Phone, GSTNumber, AddressLine1, City, StateName,
           CountryName, PostalCode, IsActive
    FROM master.Supplier
    ORDER BY SupplierName;
END


CREATE PROCEDURE master.SP_Get_Supplier_By_Id
    @SupplierID INT
AS
BEGIN
    SELECT SupplierID, SupplierCode, SupplierName, ContactPerson,
           Email, Phone, GSTNumber, AddressLine1, City, StateName,
           CountryName, PostalCode, IsActive
    FROM master.Supplier
    WHERE SupplierID = @SupplierID;
END


CREATE PROCEDURE master.SP_Add_Supplier
    @SupplierCode VARCHAR(50),
    @SupplierName NVARCHAR(100),
    @ContactPerson NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone VARCHAR(20),
    @GSTNumber VARCHAR(20),
    @AddressLine1 NVARCHAR(200),
    @City NVARCHAR(100),
    @StateName NVARCHAR(100),
    @CountryName NVARCHAR(100),
    @PostalCode VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    INSERT INTO master.Supplier
        (SupplierCode, SupplierName, ContactPerson, Email, Phone,
         GSTNumber, AddressLine1, City, StateName, CountryName,
         PostalCode, IsActive, CreatedDate, CreatedBy)
    VALUES
        (@SupplierCode, @SupplierName, @ContactPerson, @Email, @Phone,
         @GSTNumber, @AddressLine1, @City, @StateName, @CountryName,
         @PostalCode, @IsActive, GETDATE(), 'system');
END



CREATE PROCEDURE master.SP_Update_Supplier
    @SupplierID INT,
    @SupplierCode VARCHAR(50),
    @SupplierName NVARCHAR(100),
    @ContactPerson NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone VARCHAR(20),
    @GSTNumber VARCHAR(20),
    @AddressLine1 NVARCHAR(200),
    @City NVARCHAR(100),
    @StateName NVARCHAR(100),
    @CountryName NVARCHAR(100),
    @PostalCode VARCHAR(20),
    @IsActive BIT
AS
BEGIN
    UPDATE master.Supplier
    SET SupplierCode = @SupplierCode,
        SupplierName = @SupplierName,
        ContactPerson = @ContactPerson,
        Email = @Email,
        Phone = @Phone,
        GSTNumber = @GSTNumber,
        AddressLine1 = @AddressLine1,
        City = @City,
        StateName = @StateName,
        CountryName = @CountryName,
        PostalCode = @PostalCode,
        IsActive = @IsActive,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE SupplierID = @SupplierID;
END


CREATE PROCEDURE master.SP_Delete_Supplier
    @SupplierID INT
AS
BEGIN
    UPDATE master.Supplier
    SET IsActive = 0,
        ModifiedDate = GETDATE(),
        ModifiedBy = 'system'
    WHERE SupplierID = @SupplierID;
END