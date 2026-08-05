USE InventoryManagementDB;
GO

CREATE OR ALTER PROCEDURE master.SP_Get_Audit_Logs
    @Top INT = 500
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@Top)
        LogID,
        UserID,
        Username,
        Action,
        Details,
        IPAddress,
        LogDate
    FROM master.AuditLog
    ORDER BY LogDate DESC;
END;
GO
