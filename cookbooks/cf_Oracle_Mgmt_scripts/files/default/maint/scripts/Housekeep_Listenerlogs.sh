#!/bin/bash
#######################################################################
# Script to cleanup oracle trace logs weekly.
# Check /u01/maint/logs/GG_${DATABASE}_yyyy_mm_dd.log for issues.
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
export LOG_DIR=i/u01/maint/logs/Housekeeplogs/
LOG=${LOG_DIR}/DB_housekeep_${DATABASE}_LOGS_${Dstamp}.out
MAIL_SUBJ=" $HOSTNAME ${DATABASE} Housekeeping trace LOG: "
#MAIL_RECIPIENT="ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"
AL
exec >> $LOG 2>&1

HOST_NAME=`hostname -a`

test -d "backuplogs" || mkdir "backuplogs"

mv alert_${ORACLE_SID}.log backuplogs/alert_${ORACLE_SID}.log.${Dstamp}_bkp

# Move all trc/trm files over 7 days old into the backuplogs directory
find . -name '*.tr*' -mtime +7 | grep -v backuplogs | xargs -Ifile mv file backuplogs/file
## OR
## Move all files into the backup directory
# mv *.tr* backuplogs/
#
#--------------- Deleting error log files ----------------
#

find backuplogs -name '*' -mtime +14 -exec rm {} \;

find ${LOG_DIR}/ -name 'DB_housekeep_${DATABASE}_LOGS_*.out' -mtime +7 -exec rm {} \;

