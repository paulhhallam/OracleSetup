#!/bin/bash
#######################################################################
#       Script to run check for Backup schema everynight.
#
#       Run from oracle crontab every night
#
#############################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------------
#       15/01/2013      Ananth Shenoy   1.0     New script.
#       22/11/2013      Ananth Shenoy   1.5     Added FLASHBACK_SCN for expdp
#############################################################################
#
################ SETTING UP VARIABLES #################
#
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
export ORACLE_SID=${DATABASE}
export ORAENV_ASK=NO
. /usr/local/bin/oraenv


EMAIL_LIST="ananth.shenoy@voice-commerce.com,paul.hallam@voice-commerce.com"
#EMAIL_LIST="paul.hallam@voice-commerce.com"
export DATA_PUMP_DIR=/backup/oracle/exports/${DATABASE}
timeSuffix=`date '+%F-%H_%M_%S'`

#
################ EXPORTING SCHEMA #################
#
expdp  \'/ as sysdba\' directory=DATA_PUMP_DIR dumpfile=$prefix"_"$timeSuffix.dmp logfile=$prefix"_"$timeSuffix.log schemas=$prefix flashback_time=\"TO_TIMESTAMP \(TO_CHAR \(SYSDATE, \'YYYY-MM-DD HH24:MI:SS\'\), \'YYYY-MM-DD HH24:MI:SS\'\)\"
echo "GZIP DO"
gzip $DATA_PUMP_DIR/$prefix"_"$timeSuffix.dmp
echo "GZIP END"
#
################ EMAILING LOGS ####################
#
ERRCOUNT=`grep "successfully completed" $DATA_PUMP_DIR/$prefix"_"$timeSuffix.log | wc -l`
if [ "$ERRCOUNT" -eq 1 ];
     then
          find $DATA_PUMP_DIR -name "$prefix*.dmp.gz" -mtime +2 -exec rm -rfv {} \;
          find $DATA_PUMP_DIR -name "$prefix*.log"    -mtime +2 -exec rm -rfv {} \;
#         echo '$DATABASE DB Export Success on' $HOSTNAME | mail -s "$DATABASE EXPORT SUCCESSFUL on $HOSTNAME " -a $DATA_PUMP_DIR/$prefix"_"$timeSuffix.log $EMAIL_LIST
#
################ NOW CLEARDOWN ARCHIVELOGS
#
          rman target / << EOF
          delete noprompt archivelog all completed before 'sysdate-1';
          exit
EOF
     else
          echo '$DATABASE DB Export Failure on' $HOSTNAME | mail -s "$DATABASE EXPORT FAILED on $HOSTNAME " -a $DATA_PUMP_DIR/$prefix"_"$timeSuffix.log $EMAIL_LIST
fi

