#!/bin/bash
#######################################################################
#       Script to run daily RMAN backups to disk for endpoint database.
#       Run from oracle crontab daily at 2am
#       Check /u01/maint/logs/rmanlogs/rman_endpoint_backup_yyyy_mm_dd.log for issues.
#       PREREQUISITES - ORACLE_SID entry MUST exist in /etc/oratab
#######################################################################
#       Date Written: 12 December 2011 Author: A Shenoy
#######################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------
#       03/05/2016      A Shenoy        1.0     New script.
#######################################################################

. /home/oracle/endpoint.env

MAIL_RECIPIENT="oraclealerts@cashflows.com, paul.hallam@cashflows.com"
#MAIL_RECIPIENT="paul.hallam@cashflows.com"

DATABASE=endpoint
SCRIPT_DIR=/u01/maint/scripts
LOG_DIR=/u01/maint/logs/rmanlogs

export Dstamp=`date +%Y_%m_%d`
export DstampDel=`date +%Y_%m_%d --date '8 days ago'`
export DATA_DIR=${BACKUP_DIR}/${DATABASE}/backupset
#export ORACLE_SID=${DATABASE}
LOG=${LOG_DIR}/rman_full${DATABASE}_${Dstamp}.log
exec > $LOG 2>&1

################################################################################
# Create Daily backup directory
if [ ! -d ${DATA_DIR}/${Dstamp} ]; then
        mkdir -p ${DATA_DIR}/${Dstamp}
fi

# Start RMAN backup
echo Starting RMAN backup run at `date`

rman target / cmdfile=${SCRIPT_DIR}/rman_backup.rcv log=${LOG_DIR}/rmanendpointfull.log

cat ${LOG_DIR}/rmanendpointfull.log

# Check if errors in RMAN run.
RMANLOG=${LOG_DIR}/rmanendpointfull.log
ERRCOUNT=`grep RMAN- ${RMANLOG}|grep -v RMAN-08138|grep -v RMAN-08137|wc -l`
if [ "$ERRCOUNT" -ne 0 ]; then
        echo '*****************************************************************'
        echo '************** ERRORS IN THIS RMAN RUN - CHECK LOGS *************'
        echo '*****************************************************************'
        echo 'RMAN- errors detected in log file on ' $HOSTNAME | mail -s "Endpoint Daily RMAN backup - *** Error ***" -a ${RMANLOG} $MAIL_RECIPIENT
  else
        for i in `find ${LOG_DIR} -mtime +7 -print`; do echo -e "Deleting log file $i";rm -rf $i; done
        echo Removing old backup directory older than 7 days
        find "${DATA_DIR:-.}" -depth -type d -print0 |
        while read -r -d '' i
        do
                [ "$(find "$i" -type f -mtime -7 | wc -l)" -gt 0 ] && continue
                echo "Deleting backupset $i"
                rm -rf "$i"
        done

       cd $DATA_DIR
       if [ -d $DstampDel ]; then
               rm -rf $DstampDel
       fi
fi

rm ${SCRIPT_DIR}/rmanendpointfull.log
echo Completed Rman backup run at `date`

######  END OF SCRIPT ######
