USE InventoryManagementDB;
GO

/*
    Script Name : 036_Create_Customer_Table.sql
    Purpose     : Create customer master table
    Module      : Sales Management
*/


CREATE TABLE sales.Customer
(
    CustomerId INT IDENTITY(1,1)
        CONSTRAINT PK_Customer PRIMARY KEY,

    CustomerCode VARCHAR(20) NOT NULL
        CONSTRAINT UQ_Customer_Code UNIQUE,

    CustomerName VARCHAR(150) NOT NULL,

    Email VARCHAR(100) NULL,

    PhoneNumber VARCHAR(20) NULL,

    AddressLine1 VARCHAR(150) NULL,

    AddressLine2 VARCHAR(150) NULL,

    City VARCHAR(50) NULL,

    State VARCHAR(50) NULL,

    Country VARCHAR(50) NULL,

    PostalCode VARCHAR(20) NULL,


    IsActive BIT NOT NULL
        CONSTRAINT DF_Customer_IsActive DEFAULT 1,


    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Customer_CreatedDate DEFAULT SYSDATETIME(),

    CreatedBy VARCHAR(50) NOT NULL,

    ModifiedDate DATETIME2 NULL,

    ModifiedBy VARCHAR(50) NULL
);
GO