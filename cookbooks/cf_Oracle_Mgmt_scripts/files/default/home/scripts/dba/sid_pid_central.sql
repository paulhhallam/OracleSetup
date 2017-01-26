SET lines 250;
SET pages 0 embedded on;
col spid format a10;
col username format a25;
col OSUSER format a20;
ALTER SESSION SET NLS_DATE_FORMAT = 'SYYYY-MM-DD HH24:MI:SS';
TTITLE left _date center 'Oracle System Users' skip 2
SELECT a.inst_id, a.sid, a.serial#, b.spid, a.sql_id,  a.username, a.osuser, a.status, a.logon_time
 FROM gv$session a, gv$process b
 WHERE a.paddr = b.addr(+)
 and a.inst_id = b.inst_id
 and a.username in ('CENTRAL','VCG_CENTRAL_APP')
 order by 9 desc;
