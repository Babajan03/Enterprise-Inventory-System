USE InventoryManagementDB;
GO


CREATE TABLE purchase.Supplier
(
    SupplierId INT IDENTITY(1,1)
        CONSTRAINT PK_Supplier PRIMARY KEY,

    SupplierCode VARCHAR(20) NOT NULL
        CONSTRAINT UQ_Supplier_Code UNIQUE,

    SupplierName VARCHAR(150) NOT NULL,

    ContactPerson VARCHAR(100),

    Email VARCHAR(100),

    PhoneNumber VARCHAR(20),

    AddressLine1 VARCHAR(150),

    City VARCHAR(50),

    State VARCHAR(50),

    Country VARCHAR(50),

    PostalCode VARCHAR(20),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Supplier_IsActive DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Supplier_CreatedDate DEFAULT SYSDATETIME(),

    CreatedBy VARCHAR(50) NOT NULL
);

GO