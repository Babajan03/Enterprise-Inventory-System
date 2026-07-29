USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_All_Users
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        UserID,
        Username,
        FullName,
        Email,
        Role,
        IsActive,
        CreatedDate
    FROM master.[User]
    ORDER BY CreatedDate DESC;
END;
GO
