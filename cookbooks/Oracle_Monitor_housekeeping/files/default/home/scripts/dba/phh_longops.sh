#!/bin/bash

sql()
{
sqlplus -s -s '/ as sysdba' << eof | grep -v ^$
set feedback off
set head off
select instance_name from v\$instance;
select name from v\$database;
eof
}

info=`sql`
inst=`echo $info | cut -f1 -d" "`
db=`echo $info | cut -f2 -d" "`


while :
do
clear
echo "`tput rev`Time:[`date`] Host:[`uname -n`] Db:[$db] Inst:[$inst]`tput sgr0`"
sqlplus -s '/ as sysdba' << eof | grep -v ^$
set lines 120
set pages 60
set feedback off
set head off
column INST format 999 heading 'Inst'
column CMD format a35 heading 'Command'
column STT format a20 heading 'Start Time'
column SOFAR format 9,999,999,999 heading 'Completed Wrk'
column TOTWRK format 9,999,999,999 heading 'Total Wrk'
column PCT format 999 heading '%'
column END format a8 heading 'End Est.'
--select to_char(sysdate, 'DD-MON-YY HH24:MI:SS') from dual;
set head on
select inst_id INST,
        to_char(start_time, 'DD-MON-YY HH24:MI:SS') STT,
        sofar SOFAR,
        totalwork TOTWRK,
        sofar/totalwork * 100 PCT,
        to_char(sysdate + (time_remaining/24/60/60),'HH24:MI') End,
        opname CMD
from gv\$session_longops
where totalwork > 0
and sofar/totalwork * 100 < 100
and totalwork > 0
order by 6;

--column "AVG CR BLOCK RECEIVE TIME (ms)" format 9999999.9
--select b1.inst_id, b2.value "GCS CR BLOCKS RECEIVED",
--b1.value "GCS CR BLOCK RECEIVE TIME",
--((b1.value / b2.value) * 10) "AVG CR BLOCK RECEIVE TIME (ms)"
--from gv\$sysstat b1, gv\$sysstat b2
--where b1.name = 'global cache cr block receive time' and
--b2.name = 'global cache cr blocks received' and b1.inst_id = b2.inst_id ;
eof
sleep 15
done


