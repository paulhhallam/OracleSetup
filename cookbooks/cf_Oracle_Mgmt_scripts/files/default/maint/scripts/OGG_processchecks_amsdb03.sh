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
################ SETTING UP VARIABLES #################
#
EMAIL_LIST="database-monitors@cashflows.pagerduty.com, ananth.shenoy@cashflows.com, paul.hallam@cashflows.com"
#EMAIL_LIST="oraclealerts@cashflows.com, paul.hallam@cashflows.com"
#EMAIL_LIST="paul.hallam@cashflows.com"
host=`hostname`
timeSuffix=`date +%F_%T`
gghome=/backup/oracle/OGG
ggcentral=/backup/oracle/OGG/central
ggaccounts=/backup/oracle/OGG/accounts
ggendpoint=/backup/oracle/OGG/endpoint

trap "echo 'OGG_processchecks failed on $HOSTNAME ' $HOSTNAME | mail -s 'OGG_processchecks failed on $HOSTNAME ' $EMAIL_LIST" INT TERM EXIT

#================ CHECKING FOR ACCOUNTS MANAGER ==============================

check_mgr1=`ps -ef|grep mgr | grep accounts|grep -v "grep mgr"|wc -l`;
check_num3=`expr $check_mgr1`
if [ $check_num3 -le 0 ]
   then
        echo "GoldenGate Accounts Manager is down on $host." > $ggaccounts/maint/Manager_$timeSuffix.out
        tail -30 $ggaccounts/ggserr.log >> $ggaccounts/maint/manager_$timeSuffix.out
        mail -s "GoldenGate accounts Manager Down on $host" $EMAIL_LIST < $ggaccounts/maint/Manager_$timeSuffix.out
fi

find $ggaccounts/maint/ -name 'Manager_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT MANAGER ==============================

check_mgr2=`ps -ef|grep mgr | grep endpoint|grep -v "grep mgr"|wc -l`;
check_num6=`expr $check_mgr2`
if [ $check_num6 -le 0 ]
   then
        echo "GoldenGate ENDPOINT Manager is down on $host." > $ggendpoint/maint/Manager_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/manager_$timeSuffix.out
        mail -s "GoldenGate ENDPOINT Manager Down on $host" $EMAIL_LIST < $ggendpoint/maint/Manager_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'Manager_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL MANAGER ================================

check_mgr3=`ps -ef|grep mgr | grep central|grep -v "grep mgr"|wc -l`;
check_num9=`expr $check_mgr3`
if [ $check_num9 -le 0 ]
   then
        echo "GoldenGate CENTRAL Manager is down on $host." > $ggcentral/maint/Manager_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/manager_$timeSuffix.out
        mail -s "GoldenGate CENTRAL Manager Down on $host" $EMAIL_LIST < $ggcentral/maint/Manager_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'Manager_*.out' -mtime +7 -exec rm {} \;


#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS REPLICAT ===============
#
check_rep1=`ps -ef|grep AMSACRP|grep -v "grep AMSACRP"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Accounts Replicat AMSACRP is down on $host." > $ggaccounts/maint/amsacrep_$timeSuffix.out
        tail -30 $ggaccounts/ggserr.log >> $ggaccounts/maint/amsacrep_$timeSuffix.out
        mail -s "GoldenGate AMSACRP Down on $host" $EMAIL_LIST < $ggaccounts/maint/amsacrep_$timeSuffix.out
fi

find $ggaccounts/maint/ -name 'amsacrep_*.out' -mtime +7 -exec rm {} \;
#
#
#~~~~~~~~~~~~~~~~ CHECKING FOR ENDPOINT REPLICAT ~~~
#
check_rep2=`ps -ef|grep AMSEPRP|grep -v "grep AMSEPRP"|wc -l`;
check_num1=`expr $check_rep2`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Accounts Replicat AMSEPRP is down on $host." > $ggendpoint/maint/amseprep_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/amseprep_$timeSuffix.out
        mail -s "GoldenGate AMSEPRP Down on $host" $EMAIL_LIST < $ggendpoint/maint/amseprep_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'amseprep_*.out' -mtime +7 -exec rm {} \;

#------------------ CHECKING FOR CENTRAL REPLICAT -----------------
#
check_rep3=`ps -ef|grep AMSCNRP|grep -v "grep AMSCNRP"|wc -l`;
check_num2=`expr $check_rep3`
if [ $check_num2 -le 0 ]
   then
        echo "GoldenGate Central Replicat AMSCNRP is down on $host." > $ggcentral/maint/amscnrep_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/amscnrep_$timeSuffix.out
        mail -s "GoldenGate AMSCNRP Down on $host" $EMAIL_LIST < $ggcentral/maint/amscnrep_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'amscnrep_*.out' -mtime +7 -exec rm {} \;

#<><><><><><><><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS EXTRACT ===============
#
check_rep1=`ps -ef|grep AMSACEXT|grep -v "grep AMSACEXT"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Accounts Extract AMSACEXT is down on $host." > $ggaccounts/maint/amsacext_$timeSuffix.out
        tail -30 $ggaccounts/ggserr.log >> $ggaccounts/maint/amsacext_$timeSuffix.out
        mail -s "GoldenGate AMSACEXT Down on $host" $EMAIL_LIST < $ggaccounts/maint/amsacext_$timeSuffix.out
fi

find $ggaccounts/maint/ -name 'amsacext_*.out' -mtime +7 -exec rm {} \;
#
#
#================ CHECKING FOR CENTRAL EXTRACT ===============
#
check_rep1=`ps -ef|grep AMSCNEXT|grep -v "grep AMSCNEXT"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Central Extract AMSCNEXT is down on $host." > $ggcentral/maint/amscnext_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/amscnext_$timeSuffix.out
        mail -s "GoldenGate AMSCNEXT Down on $host" $EMAIL_LIST < $ggcentral/maint/amscnext_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'amscnext_*.out' -mtime +7 -exec rm {} \;
#
#
#~~~~~~~~~~~~~~~~ CHECKING FOR ENDPOINT EXTRACT ~~~
#
check_rep2=`ps -ef|grep AMSEPEXT|grep -v "grep AMSEPEXT"|wc -l`;
check_num1=`expr $check_rep2`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Endpoint Extract AMSEPEXT is down on $host." > $ggendpoint/maint/amsepext_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/amsepext_$timeSuffix.out
        mail -s "GoldenGate AMSEPEXT Down on $host" $EMAIL_LIST < $ggendpoint/maint/amsepext_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'amseprep_*.out' -mtime +7 -exec rm {} \;

#<><><><><><><><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS PUMP ===============
#
check_rep1=`ps -ef|grep DWHACDP|grep -v "grep DWHACDP"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Accounts Pump DWHACDP is down on $host." > $ggaccounts/maint/dwhacdp_$timeSuffix.out
        tail -30 $ggaccounts/ggserr.log >> $ggaccounts/maint/dwhacdp_$timeSuffix.out
        mail -s "GoldenGate DWHACDP Down on $host" $EMAIL_LIST < $ggaccounts/maint/dwhacdp_$timeSuffix.out
fi

find $ggaccounts/maint/ -name 'dwhacdp_*.out' -mtime +7 -exec rm {} \;
#
#
#================ CHECKING FOR CENTRAL PUMP ===============
#
check_rep1=`ps -ef|grep DWHCNDP|grep -v "grep DWHCNDP"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Central Pump DWHCNDP is down on $host." > $ggcentral/maint/dwhcndp_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/dwhcndp_$timeSuffix.out
        mail -s "GoldenGate DWHCNDP Down on $host" $EMAIL_LIST < $ggcentral/maint/dwhcndp_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'dwhcndp_*.out' -mtime +7 -exec rm {} \;
#
#
#================ CHECKING FOR ENDPOINT PUMP ===============
#
check_rep1=`ps -ef|grep DWHEPDP|grep -v "grep DWHEPDP"|wc -l`;
check_num=`expr $check_rep1`
if [ $check_num -le 0 ]
   then
        echo "GoldenGate Endpoint Pump DWHEPDP is down on $host." > $ggendpoint/maint/dwhepdp_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/dwhepdp_$timeSuffix.out
        mail -s "GoldenGate DWHEPDP Down on $host" $EMAIL_LIST < $ggendpoint/maint/dwhepdp_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'dwhepdp_*.out' -mtime +7 -exec rm {} \;
#
#

trap - INT TERM EXIT


