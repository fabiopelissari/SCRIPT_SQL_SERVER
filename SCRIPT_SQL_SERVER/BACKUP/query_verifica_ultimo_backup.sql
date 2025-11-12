------------------------------------------------------------
--
-- Verifica Ultimo Backup 
-- 
-- Fabio Pelissari
--
------------------------------------------------------------
SELECT SERVERPROPERTY('Servername') AS 'Servidor',
       msdb.dbo.backupset.database_name As 'Database',
       CASE msdb..backupset.type
        WHEN 'D' THEN 'Database'
        WHEN 'L' THEN 'Log'
        WHEN 'I' THEN 'Diferencial'
        WHEN 'F' THEN 'File ou Filegroup'
        WHEN 'G' THEN 'Diferencial Arquivo'
        WHEN 'P' THEN 'Parcial'       
        WHEN 'Q' THEN 'Diferencial Parcial'
       END AS 'Tipo do Backup',
       MAX(msdb.dbo.backupset.backup_start_date) As 'Data Execuo'
FROM msdb.dbo.backupmediafamily INNER JOIN msdb.dbo.backupset
  ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 103) >= GETDATE()-15)
GROUP BY msdb.dbo.backupset.database_name, msdb..backupset.type
ORDER BY 2, 4