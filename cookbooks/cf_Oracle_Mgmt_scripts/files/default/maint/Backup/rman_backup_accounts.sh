#!/bin/bash


. /home/oracle/accounts.env

MAIL_RECIPIENT="paul"
DATABASE=accounts
SCRIPT_DIR=/u01/maint/scripts
LOG_DIR=/u01/maint/logs/rmanlogs/accounts

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

rman target / cmdfile=${SCRIPT_DIR}/rman_backup.rcv log=${LOG_DIR}/rmanaccountsfull.log

cat ${LOG_DIR}/rmanaccountsfull.log

# Check if errors in RMAN run.
RMANLOG=${LOG_DIR}/rmanaccountsfull.log
ERRCOUNT=`grep RMAN- ${RMANLOG}|grep -v RMAN-08138|grep -v RMAN-08137|wc -l`
if [ "$ERRCOUNT" -ne 0 ]; then
        echo '*****************************************************************'
        echo '************** ERRORS IN THIS RMAN RUN - CHECK LOGS *************'
        echo '*****************************************************************'
        echo 'RMAN- errors detected in log file on ' $HOSTNAME | mail -s "Accounts Daily RMAN backup - *** Error ***" -a ${RMANLOG} $MAIL_RECIPIENT
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

rm ${LOG_DIR}/rmanaccountsfull.log
echo Completed Rman backup run at `date`

######  END OF SCRIPT ######
