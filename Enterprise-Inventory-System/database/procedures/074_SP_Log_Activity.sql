USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Log_Activity
    @UserID INT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Action NVARCHAR(100),
    @Details NVARCHAR(MAX) = NULL,
    @IPAddress NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO master.AuditLog (UserID, Username, Action, Details, IPAddress)
    VALUES (@UserID, @Username, @Action, @Details, @IPAddress);
END;
GO
