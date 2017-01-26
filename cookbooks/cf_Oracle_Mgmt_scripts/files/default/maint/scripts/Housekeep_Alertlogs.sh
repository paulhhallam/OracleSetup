#!/bin/bash
#
# This procedure relies on the instance being in /etc/oratab.
# For clustered instances the sid must be in oratab, not the global instance name.
# In theory we could use the global name and add the instanbce number as used by ASM 
# BUT the problem here is that the instance number does not have to be the same for 
# all instances on a host.
#
# http://www.dbaexpert.com/blog/rotate-all-the-log-files-in-the-rac-environment/
#
shopt -s expand_aliases
export Dstamp=`date +%F`
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
# -- Housekeep the ASM alert Log
#===============================
#
if [ $USER = $ASM_OWNER ]; then
   export ORACLE_SID=$ASM_RUNNING
   export ORAENV_ASK=NO
   . oraenv -s
   export GRID_HOME=$ORACLE_HOME
   export PATH=$ORACLE_HOME/bin:$PATH
   DIAG_DEST=`sqlplus -s / as sysdba << EOF1
   set heading off
   set feedback off
   set recsep off
   set pagesize 0
   set termout off
   select value from v\\$diag_info where name = 'Diag Trace' and inst_id = \$ASM_INSTANCE_ID;
   exit
EOF1`
   export ASM_LOG=$DIAG_DEST/alert_${ORACLE_SID}.log
   cd $DIAG_DEST
   HKLOGS=/backup/oracle/logs/ALERT/ASM
   test -d $HKLOGS || mkdir -p $HKLOGS
   mv alert_${ORACLE_SID}.log $HKLOGS/alert_${ORACLE_SID}.log.${Dstamp}_bkp
   find -name '*.tr*' -mtime +7 | xargs -Ifile mv file $HKLOGS/file
#
# tar and gzip the new files
#
    cd $HKLOGS
    find . -name '*.tr*' -print >/tmp/ASMalerts.txt
    tar -czf trace_${Dstamp}.tar.gz -T /tmp/ASMalerts.txt
    find $HKLOGS -name '*.tr*' | xargs rm
    rm /tmp/ASMalerts.txt
#
# Remove all files over two weeks old
#
    find $HKLOGS/ -name '*' -mtime +14 -exec rm {} \;
fi

#
# -- Housekeep the database alert logs
#=====================================
#
for DATABASES in $(ps -ef |grep -i pmon |grep -v ASM |grep -v MGMTDB|awk {'print $8'} |sed "s/ora_pmon_//g" |egrep -v "sed|grep")
do
#
# -- Housekeep the alert logs
#
  DB_OWNER=$(ps -ef |grep $DATABASES |grep -v ASM |grep -v MGMTDB|grep ora_pmon| awk {'print $1'} )
  if [ $USER = $DB_OWNER ]; then
    export DB=$(echo $DATABASES |sed '$s/.$//')
    export ORACLE_SID=$DATABASES
    export ORAENV_ASK=NO
    . oraenv -s
    export PATH=$ORACLE_HOME/bin:$PATH
    echo "PROCESSING ******************* $ORACLE_SID ****************************"
    DIAG_DEST=`sqlplus -s / as sysdba << EOF1
       set heading off
       set feedback off
       set recsep off
       set pagesize 0
       set termout off
       select value from v\\$diag_info where name = 'Diag Trace' and inst_id = \$ASM_INSTANCE_ID;
       exit
EOF1`
    export DB_LOG=$DIAG_DEST/alert_${ORACLE_SID}.log
    echo "DATABASE ALERT LOG $DB_LOG"
    cd $DIAG_DEST
    HKLOGS=/backup/oracle/logs/ALERT/${DATABASES}
    test -d $HKLOGS || mkdir -p $HKLOGS
#
# Move the files to the backup directory
#
    mv alert_${ORACLE_SID}.log $HKLOGS/alert_${ORACLE_SID}.log.${Dstamp}_bkp
    find . -name '*.tr*' -mtime +7 | xargs -Ifile mv file $HKLOGS/file
#
# tar and gzip the new files
#
    cd $HKLOGS
    find -name '*.tr*' -print >/tmp/DBalerts.txt
    tar -czf trace_${Dstamp}.tar.gz -T /tmp/DBalerts.txt
    find $HKLOGS -name '*.tr*' | xargs rm
    rm /tmp/DBalerts.txt
#
# Remove all files over two weeks old
#
    find $HKLOGS/ -name '*' -mtime +14 -exec rm {} \;

  fi
#
done


