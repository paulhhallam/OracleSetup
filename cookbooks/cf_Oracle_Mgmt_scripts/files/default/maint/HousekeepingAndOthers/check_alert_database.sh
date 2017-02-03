#!/bin/bash
#######################################################################
# Script to monitor alert log for every 10 mins.
# Run from oracle crontab every 5 minutes.
# Check /backup/oracle/logs/ALOG/ for issues.
#
# PREREQUISITES 
# PREREQUISITES 
# PREREQUISITES - ORACLE_SID entry MUST exist in /etc/oratab
#
#######################################################################
#       Date Written: 11 December 2012  Author: A Shenoy
#######################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------
#       11/12/2012      A Shenoy        1.0     New script.
#       25/07/2016      Paul Hallam     2.0     Moved to ASMDB03
#
#######################################################################

HOST_NAME=`hostname -a`
MAIL_RECIPIENT="ananth.shenoy@cashflows.com,paul.hallam@cashflows.com"

trap "echo 'CHECK_ALERT_DATABASE.SH failed on $HOSTNAME ' $HOSTNAME | mail -s 'CHECK_ALERT_DATABASE.SH failed on $HOSTNAME ' $MAIL_RECIPIENT" INT TERM EXIT

#
# -- PROCESS ASM
#
#
# -- Get the asm owner and instance name
#
. ~/.bash_profile
export PATH=/usr/local/bin:$PATH

export ASM_OWNER=$(ps -ef |grep -i asm_pmon | grep -v grep | awk {'print $1'})
export ASM_RUNNING=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep")
[ "$ASM_RUNNING" != "" ] && ASM_INSTANCE=$(echo $ASM_RUNNING |sed '$s/.$//')
export ASM_INSTANCE_ID=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep"| sed "s/+ASM//g")
if [ "$ASM_INSTANCE_ID" = "" ]; then
   ASM_INSTANCE_ID=1
fi

#
# -- Housekeep the ASM ADRCI 
#============================
#
if [ $USER = $ASM_OWNER ]; then
   MAIL_SUBJ="$HOSTNAME ASM ALERT LOG: "
   export ORACLE_SID=$ASM_RUNNING
   export ORAENV_ASK=NO
   . oraenv -s
   export GRID_HOME=$ORACLE_HOME
   export PATH=$ORACLE_HOME/bin:$PATH

   HKLOGS=/backup/oracle/logs/ALOG/ASM
   test -d $HKLOGS || mkdir -p $HKLOGS
   LOG=${HKLOGS}/altlog_ASM.out
   adrci_home=( $(adrci exec="show homes" | grep -e asm ))
   echo ' Housekeeping '$adrci_home
   echo $adrci_home' Housekeeping ' > $LOG

   echo '####################################################' >> $LOG
   echo '######## ALERT LOG OUTPUT FOR LAST 10 MINS #########' >> $LOG
   echo '####################################################' >> $LOG
   echo ''  >> $LOG
   echo $adrci_home' Alert Log' >> $LOG
    adrci exec="set home ${adrci_home}; show alert -p ""message_text like '%ORA-%' and originating_timestamp > systimestamp-10/1440"" " -term >> $LOG
#   adrci exec="set home diag/rdbms/central/central; show alert -p ""message_text like '%ORA-%' and originating_timestamp > systimestamp-10/1440"" " -term
   num_errors=`grep -c -e 'TNS' -e 'ORA' $LOG`
   if [ $num_errors != 0 ]
   then
      MAIL_SUBJ=$MAIL_SUBJ" Errors Found in Alert Summary"
      mailx -s "$MAIL_SUBJ" $MAIL_RECIPIENT < $LOG
   fi
#
#--------------- Deleting error log files for Database ----------------
#
   rm $LOG
fi



for DATABASES in $(ps -ef |grep -i pmon |grep -v ASM |grep -v MGMTDB|awk {'print $8'} |sed "s/ora_pmon_//g" |egrep -v "sed|grep")
do
  DB_OWNER=$(ps -ef |grep $DATABASES |grep -v ASM |grep -v MGMTDB|grep ora_pmon| awk {'print $1'} )
  if [ $USER = $DB_OWNER ]; then
    MAIL_SUBJ="$HOSTNAME ${DATABASES} ALERT LOG: "
    export DB=$(echo $DATABASES |sed '$s/.$//')
    export ORACLE_SID=$DATABASES
    export ORAENV_ASK=NO
    . oraenv -s
    export PATH=$ORACLE_HOME/bin:$PATH
    export Dstamp=`date +%F_%T`

    HKLOGS=/backup/oracle/logs/ALOG/${DATABASES}
    test -d $HKLOGS || mkdir -p $HKLOGS
    LOG=${HKLOGS}/altlog_${DATABASES}.out
    adrci_home=( $(adrci exec="show homes" | grep -e rdbms |grep ${DATABASES}))
    echo ' Checking alert log for '$adrci_home
    echo ' Checking alert log for '$adrci_home > $LOG

#    exec >> $LOG 2>&1
    HOST_NAME=`hostname -a`

    echo '####################################################' >> $LOG
    echo '######## ALERT LOG OUTPUT FOR LAST 10 MINS #########' >> $LOG
    echo '####################################################' >> $LOG
    echo ''  >> $LOG
    echo $adrci_home' Alert Log' >> $LOG
#    adrci exec="set home ${adrci_home}; show alert -p \\\"message_text like '%ORA-%' and originating_timestamp > systimestamp-10/1440\\\"" -term >> $LOG
    adrci exec="set home ${adrci_home}; show alert -p ""message_text like '%ORA-%' and originating_timestamp > systimestamp-10/1440"" " -term >> $LOG
    num_errors=`grep -c -e 'TNS' -e 'ORA' $LOG`
    if [ $num_errors != 0 ]
    then
      MAIL_SUBJ=$MAIL_SUBJ" Errors Found in Alert Summary"
      mailx -s "$MAIL_SUBJ" $MAIL_RECIPIENT < $LOG
    fi
#
#--------------- Deleting error log files for Database ----------------
#
    rm $LOG
  fi
done
# End the error trap
trap - INT TERM EXIT
