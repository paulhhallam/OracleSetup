#!/bin/bash
#######################################################################
# Script to cleanup oracle Golden Gate error log weekly.
# Check GG_${DATABASE}_yyyy_mm_dd.log for issues.
#
#######################################################################
#       Date Written: 16 September 2016  Author: P Hallam
#######################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------
#       16/09/2016      P Hallam        1.0     New script.
#
#######################################################################

shopt -s expand_aliases

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

export Dstamp=`date +%F_%T`
HKLOGS=/backup/oracle/logs/GG/${DATABASE}
LOG=${HKLOGS}/GG_housekeep_${DATABASE}_${Dstamp}.out
MAIL_SUBJ=" $HOSTNAME ${DATABASE} Golden Gate LOG: "
MAIL_RECIPIENT="ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"

trap "echo 'Housekeep_GoldenGateLogs failed for $DATABASE on $HOSTNAME ' $HOSTNAME | mail -s 'Housekeep_GoldenGateLogs for $DATABASE failed on $HOSTNAME ' $MAIL_RECIPIENT" INT TERM EXIT

echo "LOGS go to $HKLOGS"

GG
exec >> $LOG 2>&1

HOST_NAME=`hostname -a`
test -d $HKLOGS || mkdir -p $HKLOGS
cp -p ggserr.log $HKLOGS/ggserr.log.${Dstamp}
cat /dev/null > ggserr.log
#
#--------------- Deleting error log files ----------------
#
echo "ggserr.log maintained" >> $LOG

find $HKLOGS/ -name 'ggserr.log.*' -mtime +7 -exec rm {} \;

find ${HKLOGS}/ -name 'GG_housekeep_${DATABASE}_*.out' -mtime +7 -exec rm {} \;

# End of the error trap
trap - INT TERM EXIT