#!/bin/bash
#######################################################################
# Script to cleanup oracle logs daily.
# Check /u01/maint/logs/housekeeping/${DATABASE}/altlog_${DATABASE}_yyyy_mm_dd.log for issues.
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
   export ORACLE_SID=$ASM_RUNNING
   export ORAENV_ASK=NO
   . oraenv -s
   export GRID_HOME=$ORACLE_HOME
   export PATH=$ORACLE_HOME/bin:$PATH

   export Dstamp=`date +%F_%T`
   HKLOGS=/backup/oracle/logs/ADRCI/ASM
   test -d $HKLOGS || mkdir -p $HKLOGS
   LOG=${HKLOGS}/housekeep_ADRCI_${Dstamp}.out

   HOST_NAME=`hostname -a`
   adrci_home=( $(adrci exec="show homes" | grep -e asm ))
   echo ' Housekeeping '$adrci_home
   echo $adrci_home' Housekeeping ' >> $LOG
#
# Purge uses the time in minutes, 10080 = 7 days, 20160 = 14 days
#
   adrci exec="set home ${adrci_home}; purge -age 20160" >> $LOG
#
   find ${HKLOGS}/ -name 'housekeep_ADRCI_*.out' -mtime +7 -exec rm {} \;
fi

#
# -- Housekeep the DATABASE ADRCI
#================================
#
for DATABASES in $(ps -ef |grep -i pmon |grep -v ASM |grep -v MGMTDB|awk {'print $8'} |sed "s/ora_pmon_//g" |egrep -v "sed|grep")
do
  DB_OWNER=$(ps -ef |grep $DATABASES |grep -v ASM |grep -v MGMTDB|grep ora_pmon| awk {'print $1'} )
  if [ $USER = $DB_OWNER ]; then
    export DB=$(echo $DATABASES |sed '$s/.$//')
    export ORACLE_SID=$DATABASES
    export ORAENV_ASK=NO
    . oraenv -s
    export PATH=$ORACLE_HOME/bin:$PATH

    export Dstamp=`date +%F_%T`
    HKLOGS=/backup/oracle/logs/ADRCI/${DATABASES}
    test -d $HKLOGS || mkdir -p $HKLOGS
    LOG=${HKLOGS}/housekeep_ADRCI_${Dstamp}.out

    HOST_NAME=`hostname -a`
    adrci_home=( $(adrci exec="show homes" | grep -e rdbms |grep ${DATABASES}))
    echo ' Housekeeping '$adrci_home
    echo $adrci_home' Housekeeping ' >> $LOG
#
# Purge uses the time in minutes, 10080 = 7 days, 20160 = 14 days
#
    adrci exec="set home ${adrci_home}; purge -age 20160" >> $LOG

#
#--------------- Deleting error log files ----------------
#
    find ${HKLOGS}/ -name 'housekeep_ADRCI_*.out' -mtime +7 -exec rm {} \;
  fi
done

