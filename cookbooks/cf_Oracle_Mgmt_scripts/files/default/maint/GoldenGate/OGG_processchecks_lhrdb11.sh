#!/bin/bash

function check_extr {

check_rep1=`ps -ef | grep $1 | grep -i $3 | grep -v "grep $1" | wc -l`;

check_num=`expr $check_rep1`

# For LHRDB11 the checks are run every 5 mminutes.
# As Goldengate will try 3 times with 5 minute intervals, if the
# GG process is down for four consecutive runs we know there is an issue.
#
# Is the GoldenGate process missing
if [ $check_num -le 0 ]
then
#  If this is not the first time the process has been missing
   if [ -e "/tmp/GG_$1_$3_Issue1.txt" ]; then
      rm /tmp/GG_$1_$3_Issue1.txt
      touch /tmp/GG_$1_$3_Issue2.txt
   else
      if [ -e "/tmp/GG_$1_$3_Issue2.txt" ]; then
         rm /tmp/GG_$1_$3_Issue2.txt
         touch /tmp/GG_$1_$3_Issue3.txt
      else
         if [ -e "/tmp/GG_$1_$3_Issue3.txt" ]; then
            echo "GoldenGate $3 $1 is down on $host." > /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
            tail -30 $2/ggserr.log >> /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
            mail -s "GoldenGate $3 $1 Down on $host" $EMAIL_LIST < /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
#           Remove the flag file as it is no longer needed
            rm /tmp/GG_$1_$3_Issue*.txt
         else
            touch /tmp/GG_$1_$3_Issue1.txt
         fi
      fi
   fi
else
#  The GG process exists. If the problem file flag exists then remove it
   if ls /tmp/GG_$1_$3_Issue*.txt > /dev/null 2>&1 ; then
      rm /tmp/GG_$1_$3_Issue*.txt
   fi
fi

find /backup/oracle/logs/GG/$3/ -name '$1*.out' -mtime +7 -exec rm {} \;

}

#
################ SET UP THE VARIABLES #################
#
#
shopt -s expand_aliases
EMAIL_LIST="paul"
host=`hostname`
timeSuffix=`date +%F`

trap "echo 'OGG_processchecks failed on $HOSTNAME ' $HOSTNAME | mail -s 'OGG_processchecks failed on $HOSTNAME ' $EMAIL_LIST" INT TERM EXIT

#
#==============================================================================
#
case "$1" in
   accounts)
        echo "accounts"
        check_extr mgr      /backup/oracle/OGG/accounts accounts
        check_extr LH11ACEX /backup/oracle/OGG/accounts accounts
        check_extr LH11ACDP /backup/oracle/OGG/accounts accounts
   ;;
   central)
        echo "central"
        check_extr mgr      /backup/oracle/OGG/central  central
        check_extr LH11CNEX /backup/oracle/OGG/central  central
        check_extr LH11CNDP /backup/oracle/OGG/central  central
   ;;
   endpoint)
        echo "endpoint"
        check_extr mgr      /backup/oracle/OGG/endpoint endpoint
        check_extr LH11EPEX /backup/oracle/OGG/endpoint endpoint
        check_extr LH11EPDP /backup/oracle/OGG/endpoint endpoint
   ;;
   *)
        echo "*** ERROR - Incorrect Parameter or No parameter supplied ***"
        echo "*** Error - Valid parameters are : accounts, central, or staging ***"
        exit 1
   ;;
esac
#
##<><><><><><><><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

trap - INT TERM EXIT
