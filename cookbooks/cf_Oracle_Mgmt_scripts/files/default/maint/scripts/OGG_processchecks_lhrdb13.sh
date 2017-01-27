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
#================ CHECKING FOR ACCOUNTS REPLICAT ==============================

check_ext1=`ps -ef|grep LH13ACRP|grep -v "grep LH13ACRP"|wc -l`;
check_num1=`expr $check_ext1`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Accounts Extract LH13ACRP is down on $host." > $ggacounts/maint/LH13ACRP_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/LH13ACRP_$timeSuffix.out
        mail -s "GoldenGate LH13ACRP Down on $host" $EMAIL_LIST < $ggacounts/maint/LH13ACRP_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'LH13ACRP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT REPLICAT ==============================

check_ext2=`ps -ef|grep LH13EPRP|grep -v "grep LH13EPRP"|wc -l`;
check_num4=`expr $check_ext2`
if [ $check_num4 -le 0 ]
   then
        echo "GoldenGate ENDPOINT Extract LH13EPRP is down on $host." > $ggendpoint/maint/LH13EPRP_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/LH13EPRP_$timeSuffix.out
        mail -s "GoldenGate LH13EPRP Down on $host" $EMAIL_LIST < $ggendpoint/maint/LH13EPRP_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'LH13EPRP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL REPLICAT ==============================

check_ext3=`ps -ef|grep LH13CNRP|grep -v "grep LH13CNRP"|wc -l`;
check_num7=`expr $check_ext3`
if [ $check_num7 -le 0 ]
   then
        echo "GoldenGate CENTRAL Extract LH13CNRP is down on $host." > $ggcentral/maint/LH13CNRP_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/LH13CNRP_$timeSuffix.out
        mail -s "GoldenGate LH13CNRP Down on $host" $EMAIL_LIST < $ggcentral/maint/LH13CNRP_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'LH13CNRP_*.out' -mtime +7 -exec rm {} \;

#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS PUMP ==============================

check_ext1=`ps -ef|grep AMSACDP|grep -v "grep AMSACDP"|wc -l`;
check_num1=`expr $check_ext1`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Accounts pump AMSACDP is down on $host." > $ggacounts/maint/AMSACDP_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/AMSACDP_$timeSuffix.out
        mail -s "GoldenGate AMSACDP Down on $host" $EMAIL_LIST < $ggacounts/maint/AMSACDP_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'AMSACDP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT PUMP ==============================

check_ext2=`ps -ef|grep AMSEPDP|grep -v "grep AMSEPDP"|wc -l`;
check_num4=`expr $check_ext2`
if [ $check_num4 -le 0 ]
   then
        echo "GoldenGate ENDPOINT pump AMSEPDP is down on $host." > $ggendpoint/maint/AMSEPDP_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/AMSEPDP_$timeSuffix.out
        mail -s "GoldenGate AMSEPDP Down on $host" $EMAIL_LIST < $ggendpoint/maint/AMSEPDP_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'AMSEPDP_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL PUMP ==============================

check_ext3=`ps -ef|grep AMSCNDP|grep -v "grep AMSCNDP"|wc -l`;
check_num7=`expr $check_ext3`
if [ $check_num7 -le 0 ]
   then
        echo "GoldenGate CENTRAL pump AMSCNDP is down on $host." > $ggcentral/maint/AMSCNDP_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/AMSCNDP_$timeSuffix.out
        mail -s "GoldenGate AMSCNDP Down on $host" $EMAIL_LIST < $ggcentral/maint/AMSCNDP_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'AMSCNDP_*.out' -mtime +7 -exec rm {} \;

#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS EXTRACT ==============================

check_ext1=`ps -ef|grep LH13ACEX|grep -v "grep LH13ACEX"|wc -l`;
check_num1=`expr $check_ext1`
if [ $check_num1 -le 0 ]
   then
        echo "GoldenGate Accounts Extract LH13ACEX is down on $host." > $ggacounts/maint/LH13ACEX_$timeSuffix.out
        tail -30 $ggacounts/ggserr.log >> $ggacounts/maint/LH13ACEX_$timeSuffix.out
        mail -s "GoldenGate LH13ACEX Down on $host" $EMAIL_LIST < $ggacounts/maint/LH13ACEX_$timeSuffix.out
fi

find $ggacounts/maint/ -name 'LH13ACEX_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR ENDPOINT EXTRACT ==============================

check_ext2=`ps -ef|grep LH13EPEX|grep -v "grep LH13EPEX"|wc -l`;
check_num4=`expr $check_ext2`
if [ $check_num4 -le 0 ]
   then
        echo "GoldenGate ENDPOINT Extract LH13EPEX is down on $host." > $ggendpoint/maint/LH13EPEX_$timeSuffix.out
        tail -30 $ggendpoint/ggserr.log >> $ggendpoint/maint/LH13EPEX_$timeSuffix.out
        mail -s "GoldenGate LH13EPEX Down on $host" $EMAIL_LIST < $ggendpoint/maint/LH13EPEX_$timeSuffix.out
fi

find $ggendpoint/maint/ -name 'LH13EPEX_*.out' -mtime +7 -exec rm {} \;

#================ CHECKING FOR CENTRAL EXTRACT ==============================

check_ext3=`ps -ef|grep LH13CNEX|grep -v "grep LH13CNEX"|wc -l`;
check_num7=`expr $check_ext3`
if [ $check_num7 -le 0 ]
   then
        echo "GoldenGate CENTRAL Extract LH13CNEX is down on $host." > $ggcentral/maint/LH13CNEX_$timeSuffix.out
        tail -30 $ggcentral/ggserr.log >> $ggcentral/maint/LH13CNEX_$timeSuffix.out
        mail -s "GoldenGate LH13CNEX Down on $host" $EMAIL_LIST < $ggcentral/maint/LH13CNEX_$timeSuffix.out
fi

find $ggcentral/maint/ -name 'LH13CNEX_*.out' -mtime +7 -exec rm {} \;


