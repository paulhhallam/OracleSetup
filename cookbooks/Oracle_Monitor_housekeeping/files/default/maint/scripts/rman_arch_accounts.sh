#!/bin/bash
#######################################################################
# Script to run daily RMAN archive backups to disk for Accounts database.
# Run from oracle crontab every hour at 45th minute
# Check /u01/maint/logs/rmanlogs/rman_accounts_arch_backup_yyyy_mm_dd.log for issues.
# PREREQUISITES - ORACLE_SID entry MUST exist in /etc/oratab
#
#######################################################################
#       Date Written: 12 December 2012  Author: A Shenoy
#######################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------
#       03/05/2016      A Shenoy        1.0     New script.
#
#######################################################################


. /home/oracle/accounts.env

MAIL_RECIPIENT="oraclealerts@cashflows.com, paul.hallam@cashflows.com"
#MAIL_RECIPIENT="paul.hallam@cashflows.com"

DATABASE=accounts
SCRIPT_DIR=/u01/maint/scripts
LOG_DIR=/u01/maint/logs/rmanlogs/accounts

export Dstamp=`date +%Y_%m_%d`
export DATA_DIR=${BACKUP_DIR}/${DATABASE}/backupset
#export ORACLE_SID=${DATABASE}
LOG=${LOG_DIR}/rman_arch_${ORACLE_SID}_${Dstamp}.log
exec >> $LOG 2>&1

################################################################################
# Create Daily backup directory
if [ ! -d ${DATA_DIR}/${Dstamp} ]; then
        mkdir -p ${DATA_DIR}/${Dstamp}
fi

# Start RMAN backup
echo Starting RMan backup run at `date`

rman target / cmdfile=${SCRIPT_DIR}/rman_backup_arch.rcv log=${LOG_DIR}/rman_arch.log

cat ${LOG_DIR}/rman_arch.log

# Check if errors in RMAN run.
RMANLOG=${LOG_DIR}/rman_arch.log
ERRCOUNT=`grep RMAN- ${RMANLOG}|grep -v RMAN-08138|wc -l`
if [ "$ERRCOUNT" -ne 0 ]; then
        echo '*****************************************************************'
        echo '************** ERRORS IN THIS RMAN RUN - CHECK LOGS *************'
        echo '*****************************************************************'
        echo 'RMAN- errors detected in log file on ' $HOSTNAME | mail -s "Accounts RMAN ARCH backup - *** Error ***" -a ${RMANLOG} $MAIL_RECIPIENT
  else
echo "Start cleanup"
        for i in `find ${LOG_DIR} -mtime +7 -print`; do echo -e "Deleting log file $i";rm -rf $i; done
        echo Removing old backup directory older than 7 days
        find "${DATA_DIR:-.}" -depth -type d -print0 |
        while read -r -d '' i
        do
                [ "$(find "$i" -type f -mtime -7 | wc -l)" -gt 0 ] && continue
                echo "Deleting backupset $i"
                rm -rf "$i"
        done
echo "Now cleanup directories"
       cd $DATA_DIR
       if [ -d $DstampDel ]; then
               rm -rf $DstampDel
       fi

       echo 'Arch backup completed Sucessfully'
fi

rm ${LOG_DIR}/rman_arch.log
echo Completed RMAN ARCH backup run at `date`

######  END OF SCRIPT ######
