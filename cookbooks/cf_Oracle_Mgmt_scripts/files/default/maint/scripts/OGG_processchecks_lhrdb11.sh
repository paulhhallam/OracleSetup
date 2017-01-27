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
#       27/03/2016      Ananth Shenoy      1.0     New script.
#
#######################################################################
#
################ SETTING UP VARIABLES #################
#
EMAIL_LIST="oraclealerts@cashflows.com, paul.hallam@cashflows.com"
#EMAIL_LIST="paul.hallam@cashflows.com"
host=`hostname`
timeSuffix=`date +%F_%T`
ggacounts=/backup/oracle/OGG/accounts
ggendpoint=/backup/oracle/OGG/endpoint
ggcentral=/backup/oracle/OGG/central

trap "echo 'OGG_processchecks failed on $HOSTNAME ' $HOSTNAME | mail -s 'OGG_processchecks failed on $HOSTNAME ' $EMAIL_LIST" INT TERM EXIT

#================ CHECKING FOR ACCOUNTS MANAGER ==============================

check_mgr1=`ps -ef|grep mgr | grep accounts|grep -v "grep mgr"|wc -l`;
check_num3=`expr $check_mgr1`
if [ $check_num3 -le 0 ]
   then
        echo "GoldenGate Accounts Manager is down on $host." > $ggacounts/maint/Manager_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/manager_$timeSuffix.out
        mail -s "GoldenGate accounts Manager Down on $host" $EMAIL_LIST < $ggacounts/maint/Manager_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'Manager_*.out' -mtime +7 -exec rm {} \;

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
#================ CHECKING FOR ACCOUNTS EXTRACT ==============================

check_ext1=`ps -ef|grep LH11ACEX|grep -v "grep LH11ACEX"|wc -l`;
check_num1=`expr $check_ext1`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Accounts Extract LH11ACEX is down on $host." > $ggacounts/maint/LH11ACEX_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/LH11ACEX_$timeSuffix.out
        mail -s "GoldenGate LH11ACEX Down on $host" $EMAIL_LIST < $ggacounts/maint/LH11ACEX_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'LH11ACEX_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT EXTRACT ==============================

check_ext2=`ps -ef|grep LH11EPEX|grep -v "grep LH11EPEX"|wc -l`;
check_num4=`expr $check_ext2`
if [ $check_num4 -le 0 ]
   then
        echo "GoldenGate ENDPOINT Extract LH11EPEX is down on $host." > $ggendpoint/maint/LH11EPEX_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/LH11EPEX_$timeSuffix.out
        mail -s "GoldenGate LH11EPEX Down on $host" $EMAIL_LIST < $ggendpoint/maint/LH11EPEX_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'LH11EPEX_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL EXTRACT ==============================

check_ext3=`ps -ef|grep LH11CNEX|grep -v "grep LH11CNEX"|wc -l`;
check_num7=`expr $check_ext3`
if [ $check_num7 -le 0 ]
   then
        echo "GoldenGate CENTRAL Extract LH11CNEX is down on $host." > $ggcentral/maint/LH11CNEX_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/LH11CNEX_$timeSuffix.out
        mail -s "GoldenGate LH11CNEX Down on $host" $EMAIL_LIST < $ggcentral/maint/LH11CNEX_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'LH11CNEX_*.out' -mtime +7 -exec rm {} \;

#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS DATAPUMP ==============================

check_pmp1=`ps -ef|grep LH11ACDP|grep -v "grep LH11ACDP"|wc -l`;
check_num2=`expr $check_pmp1`
if [ $check_num2 -le 0 ]
   then
        echo "GoldenGate Accounts datapump LH11ACDP is down on $host." > $ggacounts/maint/LH11ACDP_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/LH11ACDP_$timeSuffix.out
        mail -s "GoldenGate LH11ACDP Down on $host" $EMAIL_LIST < $ggacounts/maint/LH11ACDP_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'LH11ACDP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT DATAPUMP ==============================

check_pmp2=`ps -ef|grep LH11EPDP|grep -v "grep LH11EPDP"|wc -l`;
check_num5=`expr $check_pmp2`
if [ $check_num5 -le 0 ]
   then
        echo "GoldenGate ENDPOINT datapump LH11EPDP is down on $host." > $ggendpoint/maint/LH11EPDP_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/LH11EPDP_$timeSuffix.out
        mail -s "GoldenGate LH11EPDP Down on $host" $EMAIL_LIST < $ggendpoint/maint/LH11EPDP_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'LH11EPDP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL DATAPUMP ==============================

check_pmp3=`ps -ef|grep LH11CNDP|grep -v "grep LH11CNDP"|wc -l`;
check_num8=`expr $check_pmp3`
if [ $check_num8 -le 0 ]
   then
        echo "GoldenGate CENTRAL datapump LH11CNDP is down on $host." > $ggcentral/maint/LH11CNDP_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/LH11CNDP_$timeSuffix.out
        mail -s "GoldenGate LH11CNDP Down on $host" $EMAIL_LIST < $ggcentral/maint/LH11CNDP_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'LH11CNDP_*.out' -mtime +7 -exec rm {} \;

#
#==============================================================================

trap - INT TERM EXIT
