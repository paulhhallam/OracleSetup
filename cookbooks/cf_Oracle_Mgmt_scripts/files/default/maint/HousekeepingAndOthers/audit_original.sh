# Script create for spooling results to three files for auditing purposes
# Splunk is run against the spooled files
# This audit script is run every 15 minutes in cron
# 
cd ~
. ./accounts.env
cd /u01/maint/scripts
$ORACLE_HOME/bin/sqlplus -S monitor_user/"bSLVTZcMVPig_a2FYvC"<<EOF
set lin 200
set pagesize 0
set feedback off
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
spool '/u01/maint/scripts/audit/splunk/accounts_audits.csv' append;
select timestamp||','||os_username||','||username||','||userhost||','||obj_name||','||action_name
from dba_audit_trail
where username not in (
'DPA_AC1','DPA_AC2','CF_ACC','CF_ACC_APP','GGS_ADMIN')
and timestamp > systimestamp-numtodsinterval(902,'SECOND')
order by timestamp desc;
spool off;
EOF
#
## CENTRAL AUDITS
#
cd ~
. ./central.env
cd /u01/maint/scripts
$ORACLE_HOME/bin/sqlplus -S monitor_user/"bSLVTZcMVPig_a2FYvC"<<EOF
set lin 200
set pagesize 0
set feedback off
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
spool '/u01/maint/scripts/audit/splunk/central_audits.csv' append;
select timestamp||','||os_username||','||username||','||userhost||','||obj_name||','||action_name
from dba_audit_trail
where username not in (
'VCG_CENTRAL_APP','DPA_CN2','DPA_CN1','GGS_ADMIN')
and timestamp > systimestamp-numtodsinterval(902,'SECOND')
order by timestamp desc;
spool off;
EOF
#
## ENDPOINT AUDITS
#
cd ~
. ./endpoint.env
cd /u01/maint/scripts
$ORACLE_HOME/bin/sqlplus -S monitor_user/"bSLVTZcMVPig_a2FYvC"<<EOF
set lin 200
set pagesize 0
set feedback off
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
spool '/u01/maint/scripts/audit/splunk/endpoint_audits.csv' append;
select timestamp||','||os_username||','||username||','||userhost||','||obj_name||','||action_name
from dba_audit_trail
where username not in (
'DPA_EP1','DPA_EP2','VCG_ENDPOINT_APP','GGS_ADMIN')
and timestamp > systimestamp-numtodsinterval(902,'SECOND')
order by timestamp desc;
spool off;
EOF
