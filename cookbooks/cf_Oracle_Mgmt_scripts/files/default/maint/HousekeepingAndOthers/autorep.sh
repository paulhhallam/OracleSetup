#!/bin/bash

. /home/oracle/central.env
MAIL_SUBJ="AUTO REPRESETMENT JOB STATUS:"
LOG_DIR=/backup/oracle/logs/monitorlogs/central
timeSuffix=`date +%F`
LOGFILE=$LOG_DIR/autorepstatus_$timeSuffix.log
MAIL_RECIPIENT=""

RUNNING=`sqlplus -s <<!
monitor_user/bSLVTZcMVPig_a2FYvC
set heading off;
set feedback off;
set recsep off;
set pagesize 0;
set termout off;
select count(*) from dba_scheduler_running_jobs where job_name='AUTOREPRESENTMENT_HACK_JOB';
exit;
!`

SUCESS=`sqlplus -s <<!
monitor_user/bSLVTZcMVPig_a2FYvC
set heading off;
set feedback off;
set recsep off;
set pagesize 0;
set termout off;
select count(*) from DBA_SCHEDULER_JOB_RUN_DETAILS where job_name='AUTOREPRESENTMENT_HACK_JOB'and log_date >= trunc(sysdate);
exit;
!`

if [ $RUNNING -gt 0 ]
then
        STATUS="RUNNING"
        echo $STATUS | mail -s "$MAIL_SUBJ $STATUS " $MAIL_RECIPIENT
        exit 0
fi

if [ $SUCESS -ge 1 ]
then
        STATUS="SUCCEDED"
        echo $STATUS | mail -s "$MAIL_SUBJ $STATUS " $MAIL_RECIPIENT
        exit 0
fi
exit;
EOF
