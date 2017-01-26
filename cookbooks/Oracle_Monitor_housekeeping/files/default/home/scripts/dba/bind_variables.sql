ALTER SESSION SET NLS_DATE_FORMAT = 'SYYYY-MM-DD HH24:MI:SS';
set pages 0 embedded on;
set lines 250;
col NAME format a10;
col VALUE_STRING format a50;
select inst_id, name, value_string, was_captured, last_captured from gV$SQL_BIND_CAPTURE where sql_id='&sql_id'; 
