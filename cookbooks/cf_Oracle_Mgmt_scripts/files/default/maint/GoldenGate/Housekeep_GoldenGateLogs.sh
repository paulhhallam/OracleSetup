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

echo "cfedwh and cfebidemo and staging"
prefix="cfedwh"
. ~/cfedwh.env

SCRIPT_DIR=/u01/maint/scripts/

export Dstamp=`date +%F_%T`
HKLOGS=/backup/oracle/logs/GG
LOG=${HKLOGS}/GG_housekeep_${Dstamp}.out
MAIL_SUBJ=" $HOSTNAME Golden Gate LOG: "
MAIL_RECIPIENT="ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"

trap "echo 'Housekeep_GoldenGateLogs for $DATABASE failed on $HOSTNAME ' $HOSTNAME | mail -s 'Housekeep_GoldenGateLogs for $DATABASE failed on $HOSTNAME ' $MAIL_RECIPIENT" INT TERM EXIT

GG
exec >> $LOG 2>&1

HOST_NAME=`hostname -a`
test -d $HKLOGS || mkdir -p $HKLOGS
cp -p ggserr.log $HKLOGS/ggserr.log.${Dstamp}_bkp
cat /dev/null > ggserr.log
#
#--------------- Deleting error log files ----------------
#
echo "ggserr.log maintained" >> $LOG

find $HKLOGS/ -name 'ggserr.log.*_bkp' -mtime +7 -exec rm {} \;

find ${HKLOGS}/ -name 'GG_housekeep_${DATABASE}_*.out' -mtime +7 -exec rm {} \;

trap - INT TERM EXIT
