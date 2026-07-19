USE InventoryManagementDB;
GO


CREATE TABLE sales.SalesOrderDetail
(
    SalesOrderDetailId INT IDENTITY(1,1)
        CONSTRAINT PK_SalesOrderDetail PRIMARY KEY,


    SalesOrderId INT NOT NULL,


    ProductId INT NOT NULL,


    Quantity DECIMAL(18,2) NOT NULL,


    UnitPrice DECIMAL(18,2) NOT NULL,


    TotalPrice AS (Quantity * UnitPrice),


    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),


    CreatedBy VARCHAR(50) NOT NULL,


    CONSTRAINT FK_OrderDetail_Header
    FOREIGN KEY(SalesOrderId)
    REFERENCES sales.SalesOrderHeader(SalesOrderId)

);
GO