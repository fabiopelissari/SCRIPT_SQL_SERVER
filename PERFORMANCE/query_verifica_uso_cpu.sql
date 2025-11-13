------------------------------------------------------------
--
-- Verifica Consumo de CPU
-- 
-- Fabio Pelissari
--
------------------------------------------------------------
if object_id('tempdb..#Temp_Trace') is not null drop table #Temp_Trace
SELECT TOP 50 total_worker_time ,  sql_handle,execution_count,last_execution_time,last_worker_time
into #Temp_Trace
FROM sys.dm_exec_query_stats A
--where last_elapsed_time > 20
	--and last_execution_time > dateadd(ss,-600,getdate()) --ultimos 5 min
order by A.total_worker_time desc

select distinct *
from #Temp_Trace A
cross apply sys.dm_exec_sql_text (sql_handle)
order by 1 desc

SELECT TOP 10
    total_worker_time/execution_count AS Avg_CPU_Time
        ,execution_count
        ,total_elapsed_time/execution_count as AVG_Run_Time
        ,(SELECT
              SUBSTRING(text,statement_start_offset/2,(CASE
                                                           WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 
                                                           ELSE statement_end_offset 
                                                       END -statement_start_offset)/2
                       ) FROM sys.dm_exec_sql_text(sql_handle)
         ) AS query_text 
FROM sys.dm_exec_query_stats 

--pick your criteria

ORDER BY Avg_CPU_Time DESC
--ORDER BY AVG_Run_Time DESC
--ORDER BY execution_count DESC

SELECT TOP 15 total_worker_time/execution_count AS [Avg CPU Time],  
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,   
        ((CASE qs.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE qs.statement_end_offset  
         END - qs.statement_start_offset)/2) + 1) AS statement_text  
FROM sys.dm_exec_query_stats AS qs  
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st  
ORDER BY total_worker_time/execution_count DESC;  