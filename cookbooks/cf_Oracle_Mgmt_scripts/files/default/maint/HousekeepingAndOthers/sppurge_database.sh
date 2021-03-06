#!/bin/bash

case $1 in
  accounts)
    echo "accounts"
    prefix="cf_acc"
    . ~/accounts.env
    ;;
  central)
    echo "central"
    prefix="central"
    . ~/central.env
    ;;
  endpoint)
    echo "endpoint"
    prefix="vcg_endpoint"
    . ~/endpoint.env
    ;;
  *)
    echo "*** ERROR - Incorrect Parameter or No parameter supplied ***"
    echo "*** Error - Valid parameters are : accounts central endpoint ***"
    exit 1
    ;;
esac

DATABASE=$1
SCRIPT_DIR=/u01/maint/scripts/

MAIL_SUBJ=" $HOSTNAME ${DATABASE} STATSPACK CLEANUP COMPLETED: "
MAIL_RECIPIENT=""
LOG=/backup/oracle/logs/SPpurge/SPpurge_${DATABASE}.log
cd /backup/oracle/logs/SPpurge

exec >> $LOG 2>&1

HOST_NAME=`hostname -a`

sqlplus -s << EOF
perfstat/perfstat
@/u01/maint/scripts/sppurge_30days.sql
exit;
EOF

#echo 'Statspack cleanup completed for ' $HOSTNAME | mail -s "Stataspack cleanup completed for $DATABASE ON $HOSTNAME " $MAIL_RECIPIENT

