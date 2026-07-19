USE InventoryManagementDB;
GO


CREATE TABLE sales.SalesOrderHeader
(
    SalesOrderId INT IDENTITY(1,1)
        CONSTRAINT PK_SalesOrderHeader PRIMARY KEY,


    OrderNumber VARCHAR(30) NOT NULL
        CONSTRAINT UQ_SalesOrder_Number UNIQUE,


    CustomerId INT NOT NULL,


    OrderDate DATETIME2 NOT NULL
        CONSTRAINT DF_SalesOrder_Date DEFAULT SYSDATETIME(),


    OrderStatus VARCHAR(30) NOT NULL
        CONSTRAINT DF_SalesOrder_Status DEFAULT 'CREATED',


    TotalAmount DECIMAL(18,2)
        CONSTRAINT DF_SalesOrder_Total DEFAULT 0,


    CreatedBy VARCHAR(50) NOT NULL,


    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_SalesOrder_CreatedDate DEFAULT SYSDATETIME(),


    CONSTRAINT FK_SalesOrder_Customer
    FOREIGN KEY(CustomerId)
    REFERENCES sales.Customer(CustomerId)

);
GO