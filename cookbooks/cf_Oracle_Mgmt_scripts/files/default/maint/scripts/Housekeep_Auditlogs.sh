#!/bin/bash
#######################################################################
# Script to cleanup oracle trace logs weekly.
# Check /u01/maint/logs/GG_${DATABASE}_yyyy_mm_dd.log for issues.
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
shopt -s expand_aliases
export Dstamp=`date +%F`
#
#
. ~/.bash_profile
export PATH=/usr/local/bin:$PATH
#
# -- Housekeep the ASM audit Logs
#=================================
#
export ASM_OWNER=$(ps -ef |grep -i asm_pmon | grep -v grep | awk {'print $1'})
export ASM_RUNNING=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep")
[ "$ASM_RUNNING" != "" ] && ASM_INSTANCE=$(echo $ASM_RUNNING |sed '$s/.$//')
export ASM_INSTANCE_ID=$(ps -ef |grep -i asm_pmon |awk {'print $8'} |sed "s/asm_pmon_//g" |egrep -v "sed|grep"| sed "s/+ASM//g")
if [ "$ASM_INSTANCE_ID" = "" ]; then
   ASM_INSTANCE_ID=1
fi
if [ $USER = $ASM_OWNER ]; then
   export ORACLE_SID=$ASM_RUNNING
   export ORAENV_ASK=NO
   . oraenv -s
   export GRID_HOME=$ORACLE_HOME
   export PATH=$ORACLE_HOME/bin:$PATH
   AUDIT_DEST=`sqlplus -s / as sysdba << EOF1
      set heading off
      set feedback off
      set recsep off
      set pagesize 0
      set termout off
      select value from v\\$parameter where lower(name) = 'audit_file_dest';
      exit
EOF1`

   test -d "$AUDIT_DEST" || exit

   HKLOGS=/backup/oracle/logs/ADUMP/ASM/
   test -d $HKLOGS || mkdir -p $HKLOGS

   echo "AUDIT_DEST = $AUDIT_DEST"
   echo "BACKUP DIRECTORY = $HKLOGS"

   find $AUDIT_DEST -type f -mtime +1 > /tmp/AUDITASM.txt
   for i in $(cat /tmp/AUDITASM.txt)
   do
     if ! [[ $(lsof | grep $AUDIT_DEST/$i) ]]
       then
         if [[ $i == *".aud"* ]]
            then
            mv $i $HKLOGS/
         fi
     fi
   done

   cd $HKLOGS
   find . -name '*.aud' -print > /tmp/AUDITASM.txt
   tar -czf audits_${Dstamp}.tar.gz -T /tmp/AUDITASM.txt
   find $HKLOGS -name '*.aud' | xargs rm
   rm /tmp/AUDITASM.txt
   find $HKLOGS/ -name '*' -mtime +90 -exec rm {} \;
fi


#
# HOUSEKEEP THE DATABASE AUDIT LOGS
#
for DATABASES in $(ps -ef |grep -i pmon |grep -v ASM |grep -v MGMTDB|awk {'print $8'} |sed "s/ora_pmon_//g" |egrep -v "sed|grep")
do
#
# -- Housekeep the audit logs
#
  DB_OWNER=$(ps -ef |grep $DATABASES |grep -v ASM |grep -v MGMTDB|grep ora_pmon| awk {'print $1'} )
  if [ $USER = $DB_OWNER ]; then
    export DB=$(echo $DATABASES |sed '$s/.$//')
    export ORACLE_SID=$DATABASES
    export ORAENV_ASK=NO
    . oraenv -s
    export PATH=$ORACLE_HOME/bin:$PATH
    echo "PROCESSING ******************* $ORACLE_SID ****************************"
    AUDIT_DEST=`sqlplus -s / as sysdba << EOF1
       set heading off
       set feedback off
       set recsep off
       set pagesize 0
       set termout off
       select value from v\\$parameter where lower(name) = 'audit_file_dest';
       exit
EOF1`

    test -d "$AUDIT_DEST" || exit
    HKLOGS=/backup/oracle/logs/ADUMP/$DATABASES/
    test -d $HKLOGS || mkdir -p $HKLOGS

    echo "AUDIT_DEST = $AUDIT_DEST"
    echo "BACKUP DIRECTORY = $HKLOGS"

    find $AUDIT_DEST -type f -mtime +1 > /tmp/AUDITDB.txt
    for i in $(cat /tmp/AUDITDB.txt)
    do
      if ! [[ $(lsof | grep $AUDIT_DEST/$i) ]]
        then
          if [[ $i == *".aud"* ]]
             then
             mv $i $HKLOGS/
          fi
      fi
    done

    cd $HKLOGS
    find . -name '*.aud' -print >/tmp/AUDITDB.txt
    tar -czf audits_${Dstamp}.tar.gz -T /tmp/AUDITDB.txt
    find $HKLOGS -name '*.aud' | xargs rm
    rm /tmp/AUDITDB.txt

    find $HKLOGS/ -name '*' -mtime +90 -exec rm {} \;
  fi
done

