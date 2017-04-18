#!/bin/bash
#
# ALL DATABASES MUST BE INCLUDED IN /ETC/ORATAB for these procedures to woprk.
#
# This procedure relies on the instance being in /etc/oratab.
# For clustered instances the sid must be in oratab, not the global instance name.
# In theory we could use the global name and add the instanbce number as used by ASM 
# BUT the problem here is that the instance number does not have to be the same for 
# all instances on a host.
#
MAIL_RECIPIENT="paul"

trap "echo 'Housekeep_Listener_logs failed on $HOSTNAME ' $HOSTNAME | mail -s 'Housekeep_Listener_logs failed on $HOSTNAME ' $MAIL_RECIPIENT" INT TERM EXIT

shopt -s expand_aliases
export Dstamp=`date +%F_%T`
#
#
#
# -- PROCESS ASM
#===================
#===================
#
# -- Get the asm owner and instance name
#
. ~/.bash_profile
export PATH=/usr/local/bin:$PATH
export ASM_RUNNING=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep")
[ "$ASM_RUNNING" != "" ] && ASM_INSTANCE=$(echo $ASM_RUNNING |sed '$s/.$//')
export ASM_INSTANCE_ID=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep"| sed "s/+ASM//g")
if [ "$ASM_INSTANCE_ID" = "" ]; then
   ASM_INSTANCE_ID=1
fi
export ASM_OWNER=$(ps -ef |grep -i asm_pmon | grep -v grep | awk {'print $1'})
#
# -- If we are running as the ASM owner then Housekeep the ASM / GRID Listeners
#
if [ $USER = $ASM_OWNER ]; then
   export ORACLE_SID=$ASM_RUNNING
   export ORAENV_ASK=NO
   . oraenv -s
   export GRID_HOME=$ORACLE_HOME
   export PATH=$ORACLE_HOME/bin:$PATH
   HKLOGS=/backup/oracle/logs/LSN/ASM/
   echo "BACKUPS DIR = $HKLOGS"
   test -d $HKLOGS || mkdir -p $HKLOGS
#
# --  process any listener log files
#
#
   for LISTENER in $(ps -ef |grep -i tnslsnr |grep -i $ORACLE_HOME | grep -v grep|awk {'print $9'})
   do
      LSNR_OWNER=$(ps -ef |grep -i " $LISTENER " | grep -v grep | awk {'print $1'})
#
# -- If the listener owner is the same as this user then
#
      if [ $USER = $LSNR_OWNER ]; then
         export TNS_ADMIN=$ORACLE_HOME/network/admin
###lsn_log_dir $ORACLE_HOME $LISTENER
         LSNR_LOG_DIR=$($ORACLE_HOME/bin/lsnrctl status $LISTENER | grep "Listener Log File" | awk {'print $4'} | sed "s/\/alert\/log.xml//g")
         LSNR_LOG_NAME=$(basename $LSNR_LOG_DIR)
#
         echo "LISTENER LOG $LSNR_LOG_DIR/trace/$LSNR_LOG_NAME.log"
         cd $LSNR_LOG_DIR/trace
         test -d $HKLOGS || mkdir -p $HKLOGS
#
# --Save the listener log file in backuplogs and then clean it out
         cp $LSNR_LOG_DIR/trace/$LSNR_LOG_NAME.log $HKLOGS/$LSNR_LOG_NAME.log_$Dstamp
#        cp $LSNR_LOG_DIR/trace/$LSNR_LOG_NAME.log $HKLOGS/
         cat /dev/null > $LSNR_LOG_NAME.log
         find $HKLOGS/ -name '*.log_*' -mtime +14 -exec rm {} \;
      fi
   done
fi
#
#
#
# -- Housekeep Other Listener logs
#=====================================
#=====================================
#
for DATABASES in $(ps -ef |grep -i pmon |grep -v ASM |grep -v MGMTDB|awk {'print $8'} |sed "s/ora_pmon_//g" |egrep -v "sed|grep")
do
#
  DB_OWNER=$(ps -ef |grep $DATABASES |grep -v ASM |grep -v MGMTDB|grep ora_pmon| awk {'print $1'} )
  if [ $USER = $DB_OWNER ]; then
    export DB=$(echo $DATABASES |sed '$s/.$//')
    export ORACLE_SID=$DATABASES
    export ORAENV_ASK=NO
    . oraenv -s
    export PATH=$ORACLE_HOME/bin:$PATH 
    HKLOGS=/backup/oracle/logs/LSN/${DATABASES}
    echo "BACKUPS DIR = $HKLOGS"
    test -d $HKLOGS || mkdir -p $HKLOGS
#
# -- For each database process any listener log files
#====================================================
#
    for LISTENER in $(ps -ef |grep -i tnslsnr |grep -i $ORACLE_HOME | grep -v grep|awk {'print $9'})
    do
       export DB=$(echo $DATABASES |sed '$s/.$//')
       export ORACLE_SID=$DATABASES
       export ORAENV_ASK=NO
       . oraenv -s
       export PATH=$ORACLE_HOME/bin:$PATH
       LSNR_OWNER=$(ps -ef |grep -i " $LISTENER " | grep -v grep | awk {'print $1'})
#
# -- If the listener owner is the same as this user then
#
      if [ $USER = $LSNR_OWNER ]; then
#
        export TNS_ADMIN=$ORACLE_HOME/network/admin
        LSNR_LOG_DIR=$($ORACLE_HOME/bin/lsnrctl status $LISTENER | grep "Listener Log File" | awk {'print $4'} | sed "s/\/alert\/log.xml//g")
        LSNR_LOG_NAME=$(basename $LSNR_LOG_DIR)
        echo "LISTENER LOG $LSNR_LOG_DIR/trace/$LSNR_LOG_NAME.log"
        cd $LSNR_LOG_DIR/trace
        test -d $HKLOGS || mkdir -p $HKLOGS
#
# --Save the listener log file in backuplogs and then clean it out
        cp $LSNR_LOG_DIR/trace/$LSNR_LOG_NAME.log $HKLOGS/$LSNR_LOG_NAME.log_$Dstamp
        cat /dev/null > $LSNR_LOG_NAME.log
        find $HKLOGS/ -name '*.log_*' -mtime +14 -exec rm {} \;
      fi
    done
  fi
#
done

# end the error trap
trap - INT TERM EXIT

