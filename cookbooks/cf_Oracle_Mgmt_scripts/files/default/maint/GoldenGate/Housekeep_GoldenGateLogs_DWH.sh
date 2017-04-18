#!/bin/bash


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

# We have to use a shortened date stamp because gzip automatically interprets colons as refering to rewmote host files.
export Dstamp=`date +%F`
export LOG_DIR=/u01/maint/logs/Housekeeplogs/
HKLOGS=/backup/oracle/logs/GG/${DATABASE}
LOG=${HKLOGS}/GG_housekeep_${DATABASE}_${Dstamp}.out
MAIL_SUBJ=" $HOSTNAME ${DATABASE} Golden Gate LOG: "
MAIL_RECIPIENT="paul"

trap "echo 'Housekeep_GoldenGateLogs for $DATABASE failed on $HOSTNAME ' $HOSTNAME | mail -s 'Housekeep_GoldenGateLogs for $DATABASE failed on $HOSTNAME ' $MAIL_RECIPIENT" INT TERM EXIT

GG
exec >> $LOG 2>&1

HOST_NAME=`hostname -a`
test -d $HKLOGS || mkdir -p $HKLOGS
cp -p ggserr.log $HKLOGS/ggserr.log.${Dstamp}
cat /dev/null > ggserr.log
#
gzip $HKLOGS/ggserr.log.${Dstamp}
#
#--------------- Deleting error log files ----------------
#
echo "ggserr.log maintained" >> $LOG

# At Ananths request we will keep ALL logs for now
#find $HKLOGS/ -name 'ggserr.log.*' -mtime +7 -exec rm {} \;

find ${HKLOGS}/ -name 'GG_housekeep_${DATABASE}_*.out' -mtime +7 -exec rm {} \;

trap - INT TERM EXIT

