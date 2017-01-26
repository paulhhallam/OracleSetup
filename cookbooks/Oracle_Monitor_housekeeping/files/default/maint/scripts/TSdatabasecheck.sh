#!/bin/bash
#######################################################################
#       Script to run check for tablespace size.
#
#       Run from oracle crontab every 30 minutes
#
#######################################################################
#       Change History
#       Date            Author          Ver     Description
#----------------------------------------------------------------------
#       15/01/2013      Ananth Shenoy      1.0     New script.
#       25/07/2016      Paul Hallam        2.0     Moved to ASMDB03
#
#######################################################################
#
################ SETTING UP VARIABLES #################
#
#
#
shopt -s expand_aliases
export Dstamp=`date +%F_%T`
#
. ~/.bash_profile
export PATH=/usr/local/bin:$PATH
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
    echo "PROCESSING ******************* $ORACLE_SID ****************************"
    HKLOGS=/backup/oracle/logs/TSPACE
    LOGF=$HKLOGS/${DATABASES}/TS_${DATABASE}_${Dstamp}.txt
    MAIL_SUBJ=" $HOSTNAME : $DATABASE TSPACE WARNING"
#   MAIL_RECIPIENT="ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"
    MAIL_RECIPIENT="paul.hallam@cashflows.com"
    case "$DATABASES" in
          central)
             percentage=80
             ;;
          accounts)
             percentage=90
             ;;
          endpoint)
             percentage=75
             ;;
          *)
             percentage=90
             ;;
    esac

    CHECK=`sqlplus -s << EOF1
      monitor_user/M0n1tor
      set heading off
      set feedback off
      set recsep off
      set pagesize 0
      set termout off
      select count(*) from dba_tablespace_usage_metrics where used_percent > \$percentage;
      exit
EOF1`

echo "CHECK $CHECK"

    if [ $CHECK -ne 0 ]
    then
      echo "PERCENT "
      echo $percentage

      sqlplus -s << EOF
        monitor_user/M0n1tor
        @/u01/maint/BACKUP/scripts/tablespacecheck.sql $LOGF
        exit;
EOF

#uuencode $LogFile TS_accounts_${Dstamp}.txt
      echo 'Report attached for ' $HOSTNAME | mail -s "TABLESPACE ALERT FOR $DATABASES ON $HOSTNAME " -a $LOGF $MAIL_RECIPIENT
    fi
#
# Remove all files over two weeks old
#
    find $HKLOGS/${DATABASES} -name '*' -mtime +14 -exec rm {} \;
  fi
done

find $HKLOGS/ -name '*' -mtime +14 -exec rm {} \;

