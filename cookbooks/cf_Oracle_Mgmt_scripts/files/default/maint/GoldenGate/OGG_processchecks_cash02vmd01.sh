#!/bin/bash
#######################################################################
#       Script to run check for Goldengate Process status.
#
#       Run from oracle crontab every 5 Minutes
#
#######################################################################
#       Change History
#       Date            Author             Ver     Description
#----------------------------------------------------------------------
#       14/11/2012      Ananth Shenoy      1.0     New script.
#
#######################################################################
#
################ CHECK FOR THE RELEVANT PROCESS #################
#
#
function check_extr {
   check_rep1=`ps -ef|grep $1|grep -v "grep $1"|wc -l`;
   check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Replicat $1 is down on $host." > $2/maint/$1_$timeSuffix.out
        tail -1000 $2/ggserr.log | grep -v $1 >> $2/maint/$1_$timeSuffix.out
sqlplus -s phh/phh@cfedwh << EOF3
         insert into messages values (sysdate,'GoldenGate $1 Down on $host');
         commit;
         exit;
EOF3
#        mail -s "GoldenGate $1 Down on $host" $EMAIL_LIST < $2/maint/$1_$timeSuffix.out
fi
find $2/maint/ -name '$1*.out' -mtime +7 -exec rm {} \;
}
#
################ SET UP THE VARIABLES #################
#
#
shopt -s expand_aliases
EMAIL_LIST="ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"
host=`hostname`
timeSuffix=`date +%F`
gghome=/backup/oracle/OGG

trap "echo 'OGG_processchecks failed on $HOSTNAME ' $HOSTNAME | mail -s 'OGG_processchecks failed on $HOSTNAME ' $EMAIL_LIST" INT TERM EXIT

#
#================ CHECKING FOR MANAGER ==============================
#
#
#check_mgr1=`ps -ef|grep mgr | grep -v "grep mgr"|wc -l`;
#check_num3=`expr $check_mgr1`
#if [ $check_num3 -le 0 ]
#   then
#        echo "GoldenGate Manager is down on $host." > $gghome/maint/Manager_$timeSuffix.out
#        tail -30 $gghome/ggserr.log >> $gghome/maint/manager_$timeSuffix.out
#sqlplus -s phh/phh@cfedwh << EOF2
#         insert into messages values (sysdate,'GoldenGate Manager Down on \\$host');
#         commit;
#         exit;
#EOF2
#
##        mail -s "GoldenGate Manager Down on $host" $EMAIL_LIST < $gghome/maint/Manager_$timeSuffix.out
#fi
#
#find $gghome/maint/ -name '*.out' -mtime +14 -exec rm {} \;
#
#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS REPLICAT ===============
#
check_extr mgr      /backup/oracle/OGG
check_extr CFEACREP /backup/oracle/OGG
check_extr CFECNREP /backup/oracle/OGG
check_extr CFEEPREP /backup/oracle/OGG
check_extr DWHACREP /backup/oracle/OGG
check_extr DWHCNREP /backup/oracle/OGG
#
##<><><><><><><><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

trap - INT TERM EXIT
