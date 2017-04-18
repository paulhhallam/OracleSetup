#!/bin/bash
function check_extr {

echo "$1 $2 $3" > /backup/oracle/logs/GG/$3/$1_$timeSuffix.out

check_rep1=`ps -ef|grep $1|grep -v "grep $1"|wc -l`;
check_num=`expr $check_rep1`

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
            echo "GoldenGate $3 $1 is down on $host." >> /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
            tail -1000 $2/ggserr.log | grep -v $1 >> /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
            sqlplus -s phh/phh@cfedwh << EOF3
               insert into messages values (sysdate,'GoldenGate $1 Down on $host');
               commit;
               exit;
EOF3
#            mail -s "GoldenGate $3 $1 Down on $host" $EMAIL_LIST < /backup/oracle/logs/GG/$3/$1_$timeSuffix.out
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

find /backup/oracle/logs/GG/$3/$1_$timeSuffix.out -name '$1*.out' -mtime +7 -exec rm {} \;

}

#
################ SET UP THE VARIABLES #################
#
#
shopt -s expand_aliases
EMAIL_LIST="paul"
host=`hostname`
timeSuffix=`date +%F`
gghome=/backup/oracle/OGG

trap "echo 'OGG_processchecks failed on $HOSTNAME ' $HOSTNAME | mail -s 'OGG_processchecks failed on $HOSTNAME ' $EMAIL_LIST" INT TERM EXIT

#
#==============================================================================
#==============================================================================
#================ CHECKING FOR ACCOUNTS REPLICAT ===============
#
check_extr mgr      /backup/oracle/OGG cfedwh
check_extr CFEACREP /backup/oracle/OGG cfedwh
check_extr CFECNREP /backup/oracle/OGG cfedwh
check_extr CFEEPREP /backup/oracle/OGG cfedwh
check_extr DWHACREP /backup/oracle/OGG cfedwh
check_extr DWHCNREP /backup/oracle/OGG cfedwh
#
##<><><><><><><><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

trap - INT TERM EXIT
