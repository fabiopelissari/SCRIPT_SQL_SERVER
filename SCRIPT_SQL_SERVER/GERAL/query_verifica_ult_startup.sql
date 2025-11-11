------------------------------------------------------------
--
-- Verifica Ultimo Startup 
-- 
-- Fabio Pelissari
--
------------------------------------------------------------
SELECT cpu_count AS logical_cpu_count,
       cpu_count / hyperthread_ratio AS physical_cpu_count,
--       CAST(physical_memory_kb / 1024. AS int) AS physical_memory__mb,    --2012
       CAST(physical_memory_in_bytes / 1024. AS int) AS physical_memory_mb, --2008
       sqlserver_start_time,
       (SELECT value_in_use FROM sys.configurations WHERE name like '%max server memory%') Max_memoria_configurado
FROM sys.dm_os_sys_info;