#!/bin/bash -x
#######################################################################
#       Script to run check for Goldengate Process status.
#
#       Run from oracle crontab every 5 Minutes
#
#######################################################################
#       Change History
#       Date            Author             Ver     Description
#----------------------------------------------------------------------
#       27/03/2016      Ananth Shenoy      1.0     New script.
#
#######################################################################
#
################ SETTING UP VARIABLES #################
#
EMAIL_LIST="ananth.shenoy@cashflows.com"
#EMAIL_LIST="paul.hallam@cashflows.com"
host=`hostname`
timeSuffix=`date +%F_%T`
accountslogfile=/u01/maint/logs/agent/strtagnt_acc_$timeSuffix.txt
endpointlogfile=/u01/maint/logs/agent/strtagnt_enp_$timeSuffix.txt
centrallogfile=/u01/maint/logs/agent/strtagnt_cnt_$timeSuffix.txt
ggaacounts=/backup/oracle/GGVA/accounts
ggaendpoint=/backup/oracle/GGVA/endpoint
ggacentral=/backup/oracle/GGVA/central

##### STOPPING GG AGENT FOR ACCOUNTS ######
. ~/accounts.env

/backup/oracle/GGVA/accounts/agent.sh start

acc_ag=`ps -ef|grep agent | grep accounts|grep -v "grep agent"|wc -l`;
check_acc_ag=`expr $acc_ag`
if [ $check_acc_ag -le 0 ]
   then
        echo "GoldenGate Accounts veridata agent is not started on $host." > $accountslogfile
	echo
	echo "===================== LOGS BELOW ===========================" >> $accountslogfile
        tail -30 $ggacounts/logs/veridata-agent.log >> $accountslogfile
        mail -s "GoldenGate Accounts veridata agent is not started on $host." $EMAIL_LIST < $accountslogfile
fi

##### STOPPING GG AGENT FOR ENDPOINT ######
. ~/endpoint.env

/backup/oracle/GGVA/endpoint/agent.sh start

enp_ag=`ps -ef|grep agent | grep endpoint|grep -v "grep agent"|wc -l`;
check_enp_ag=`expr $enp_ag`
if [ $check_enp_ag -le 0 ]
   then
        echo "GoldenGate Endpoint veridata agent is not started on $host." > $endpointlogfile
        echo
        echo "===================== LOGS BELOW ===========================" >> $endpointlogfile
        tail -30 $ggendpoint/logs/veridata-agent.log >> $endpointlogfile
        mail -s "GoldenGate Endpoint veridata agent is not started on $host." $EMAIL_LIST < $endpointlogfile
fi

##### STOPPING GG AGENT FOR CENTRAL ######
. ~/central.env

/backup/oracle/GGVA/central/agent.sh start

cnt_ag=`ps -ef|grep agent | grep central|grep -v "grep agent"|wc -l`;
check_cnt_ag=`expr $cnt_ag`
if [ $check_cnt_ag -le 0 ]
   then
        echo "GoldenGate Central veridata agent is not started on $host." > $centrallogfile
        echo
        echo "===================== LOGS BELOW ===========================" >> $centrallogfile
        tail -30 $ggcentral/logs/veridata-agent.log >> $centrallogfile
        mail -s "GoldenGate Central veridata agent is not started on $host." $EMAIL_LIST < $centrallogfile
fi

find /u01/maint/logs/agent/ -name 'strtagnt_*.txt' -mtime +7 -exec rm {} \;
