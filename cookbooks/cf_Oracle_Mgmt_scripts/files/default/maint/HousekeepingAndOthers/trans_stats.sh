#!/bin/bash -x
. /home/oracle/central.env
MAIL_SUBJ="Daily_Trans_Stats"
MAIL_RECIPIENT="pp"
LOG_DIR=/backup/oracle/logs/trans_stats
spool_file=TRANS_`date +%d_%b_%Y`.txt

######-=-=-=-=-=-=-=- DELETING OLD LOCK FILES -=-=-=-=-=-=-=######

find ${LOG_DIR}/ -name 'TRANS*' -mtime +7 -exec rm {} \;

######-=-=-=-=-=-=-=- SET UP THE DATES -=-=-=-=-=-=-=######


#first_day=`sqlplus -s <<!
#monitor_user/M0n1tor
#set heading off
#set feedback off
#set recsep off
#set pagesize 0
#set termout off
#select TRUNC(TRUNC(SYSDATE , 'Year')-1 , 'Year') from dual;
#exit
#!`

first_day=`sqlplus -s <<!
monitor_user/M0n1tor
set heading off
set feedback off
set recsep off
set pagesize 0
set termout off
select TRUNC(TRUNC(SYSDATE , 'Year'), 'Year') from dual;
exit
!`

today=`sqlplus -s <<!
monitor_user/M0n1tor
set heading off
set feedback off
set recsep off
set pagesize 0
set termout off
select (sysdate) from dual;
exit
!`

#####=========== GET THE MERCHANT COUNT ============#########

sqlplus -s "/@central" << EOF
@/u01/maint/scripts/transstats.sql $first_day $today $spool_file
exit;
EOF

gzip $LOG_DIR/$spool_file
report_file=$spool_file.gz

##uuencode $LOG_DIR/$report_file $report_file | mail -s "Daily_Trans_stats" $MAIL_RECIPIENT -- -f statsman
scp -oStrictHostKeyChecking=no -i /u01/maint/scripts/manager_id_rsa /backup/oracle/logs/trans_stats/$report_file manager@awsnaiad01.cfcore.net:/opt/vcg/report/drop/live/
