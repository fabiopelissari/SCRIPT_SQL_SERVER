USE master;
GO

EXEC sp_MSforeachdb '
IF ''?'' NOT IN (''master'', ''model'', ''msdb'', ''tempdb'')
BEGIN
    PRINT ''Habilitando Query Store no banco de dados: ?'';
    ALTER DATABASE ? 
    SET QUERY_STORE = ON 
    (
        OPERATION_MODE = READ_WRITE,
        CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
        DATA_FLUSH_INTERVAL_SECONDS = 900,
        MAX_STORAGE_SIZE_MB = 100,
        INTERVAL_LENGTH_MINUTES = 60,
        SIZE_BASED_CLEANUP_MODE = AUTO,
        QUERY_CAPTURE_MODE = AUTO
    );
END
';
GO