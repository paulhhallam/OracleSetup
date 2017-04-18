#!/bin/bash


case $1 in
    accounts)
      echo "accounts"
      prefix="cf_acc"
      . ~/accounts.env
      percentage=90
      ;;
    central)
      echo "central"
      prefix="central"
      . ~/central.env
      percentage=80
      ;;
    endpoint)
      echo "endpoint"
      prefix="vcg_endpoint"
      . ~/endpoint.env
      percentage=75
      ;;
    *)
      echo "*** ERROR - Incorrect Parameter or No parameter supplied ***"
      echo "*** Error - Valid parameters are : accounts central endpoint ***"
      exit 1
      ;;
esac
#
DATABASE=$1

SCRIPT_DIR=/u01/maint/scripts/

export Dstamp=`date +%F_%T`
export LOG_DIR=/backup/oracle/logs/monitorlogs/${DATABASE}
LOG=${LOG_DIR}/sess_procs_log_${DATABASE}_${Dstamp}.out
MAIL_SUBJ=" ${DATABASE} $HOSTNAME SESS_PROCS ALERT: "
MAIL_RECIPIENT=""
exec >> $LOG 2>&1

HOST_NAME=`hostname -a`

SESS_USAGE=`sqlplus -s <<!
monitor_user/bSLVTZcMVPig_a2FYvC
set heading off
set feedback off
set recsep off
set pagesize 0
set termout off
select trunc((CURRENT_UTILIZATION/LIMIT_VALUE)*100) from v\\$resource_limit where resource_name in ('sessions');
exit;
!`

echo -n SESS_USAGE:
echo $SESS_USAGE

if [ "$SESS_USAGE" -lt 50 ]; then
	:	
elif [ "$SESS_USAGE" -ge 50 ] && [ "$SESS_USAGE" -lt 70 ]; then
	MAIL_SUBJ_SESS=$MAIL_SUBJ" Session usage at warning Level"
    mailx -s "$MAIL_SUBJ_SESS" $MAIL_RECIPIENT < $LOG
	exit 0	
elif [ "$SESS_USAGE" -ge 70 ]; then
	MAIL_SUBJ_SESS=$MAIL_SUBJ" Session usage at critical Level"
    mailx -s "$MAIL_SUBJ_SESS" $MAIL_RECIPIENT < $LOG
fi

PROC_USAGE=`sqlplus -s <<!
monitor_user/bSLVTZcMVPig_a2FYvC
set heading off
set feedback off
set recsep off
set pagesize 0
set termout off
select trunc((CURRENT_UTILIZATION/LIMIT_VALUE)*100) from v\\$resource_limit where resource_name in ('processes');
exit;
!`
echo -n PROC_USAGE: 
echo $PROC_USAGE

if [ "$PROC_USAGE" -lt 60 ]; then
        : 
elif [ "$PROC_USAGE" -ge 60 ] && [ "$PROC_USAGE" -lt 70 ]; then
        MAIL_SUBJ_PROC=$MAIL_SUBJ" Process usage at warning Level"
    mailx -s "$MAIL_SUBJ_PROC" $MAIL_RECIPIENT < $LOG
        exit 0
elif [ "$PROC_USAGE" -ge 70 ]; then
        MAIL_SUBJ_PROC=$MAIL_SUBJ" Process usage at critical Level"
    mailx -s "$MAIL_SUBJ_PROC" $MAIL_RECIPIENT < $LOG
fi

#
#--------------- Deleting error log files ----------------
#

find ${LOG_DIR}/ -name 'sess_procs_log_${DATABASE}_*.out' -mtime +2 -exec rm {} \;
