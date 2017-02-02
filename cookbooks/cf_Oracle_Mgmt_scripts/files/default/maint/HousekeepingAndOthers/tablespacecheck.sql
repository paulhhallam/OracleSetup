set termout off;
spool &1;
select tablespace_name, trunc(used_percent, 2) as percent from dba_tablespace_usage_metrics where trunc(used_percent, 2) > 50;
spool off;

