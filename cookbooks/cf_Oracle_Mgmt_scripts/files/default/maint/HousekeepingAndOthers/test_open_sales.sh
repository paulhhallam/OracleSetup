#!/bin/bash -x

. /home/oracle/endpoint.env
MAIL_SUBJ="OPEN_SALES WARNING:"
MAIL_RECIPIENT="pp"

RESP=`sqlplus -s <<!
monitor_user/M0n1tor
set heading off;
set feedback off;
set recsep off;
set pagesize 0;
set termout off;
select count(*) from vcg_endpoint.open_sales where sale_timestamp < systimestamp - INTERVAL '1' hour;
exit;
!`

if [ $RESP -gt 0 ]
then
        uuencode /u01/maint/logs/endpoint/opensales.txt opensales.txt | mail -s "${MAIL_SUBJ} $RESP message/s older than 1 hour in open_sales " $MAIL_RECIPIENT
        exit 0
fi
