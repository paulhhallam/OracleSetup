SET lines 250;
SET pages 0 embedded on;
col spid format a10;
col username format a25;
col OSUSER format a20;
--TTITLE left _date center 'Oracle System Users' skip 2
SELECT a.inst_id, a.sid, a.serial#, b.spid, a.sql_id,  a.username, a.osuser, a.status
 FROM gv$session a, gv$process b
 WHERE a.paddr = b.addr(+)
 and a.inst_id = b.inst_id
 and a.username in ('CF_ACC', 'CF_ACC_APP');
