#!/bin/bash -x
#######################################################################
#       Script to change the settle_batch_id to NULL for the auto representments
#       Run from oracle crontab at 9:30 PM.
#######################################################################
#       Change History
#       Date            Author             Ver     Description
#----------------------------------------------------------------------
#       23/12/2016      Ananth Shenoy      1.0     New script.
#######################################################################
#
################ SETTING UP VARIABLES #################
#
. /home/oracle/central.env
MAIL_SUBJ="AUTO REPRESETMENT JOB STATUS:"
LOG_DIR=/u01/maint/logs/monitorlogs/central
timeSuffix=`date +%F`
LOGFILE=$LOG_DIR/autorepstatus_$timeSuffix.log
MAIL_RECIPIENT="ananth.shenoy@cashflows.com,majdi.mgaidia@cashflows.com"
#MAIL_RECIPIENT="ananth.shenoy@cashflows.com,paul.hallam@cashflows.com,alex.tull@cashflows.com,majdi.mgaidia@cashflows.com"

RUNNING=`sqlplus -s <<!
monitor_user/M0n1tor
set heading off;
set feedback off;
set recsep off;
set pagesize 0;
set termout off;
select count(*) from dba_scheduler_running_jobs where job_name='AUTOREPRESENTMENT_HACK_JOB';
exit;
!`

SUCESS=`sqlplus -s <<!
monitor_user/M0n1tor
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
