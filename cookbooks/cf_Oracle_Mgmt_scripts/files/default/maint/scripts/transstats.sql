Set feedback off
Set pagesize 0 embedded on
Set lines 300
Set termout off
Set trimout on
Set trimspool on
--set colsep '|'
set echo off
set verify off
set und off
spool /backup/oracle/logs/trans_stats/&3

select extract(year from tran_time) YEAR, extract(month from tran_time) MOY, extract(day from tran_time) DOM, merchant_id,store_id
        case
          when card_type in (128,2,4194304,512,1048576,8192,4096,2097152) then 'MASCRD'
          when card_type in (4,1,256,2048,8,131072,524288,262144) then 'VISA'
          when card_type in (1024,16) then 'AMEX'
          else 'UNKNWN'
        end as card_type,
        count( case when tran_type=1 and tran_test=0 and auth_status='D' then 1 end) Declines,
        count( case when tran_type=1 and tran_test=0 and auth_status='A' then 1 end) Auths,
        count( case when tran_type=1 and tran_test=0 and auth_status='V' then 1 end) ValidErr,
        count( case when tran_type=1 and tran_test=0 and auth_status='R' then 1 end) Declrefrl,
        count( case when tran_type=1 and tran_test=0 and auth_status='B' then 1 end) Blocked,
        count( case when tran_type=1 and tran_test=0 and auth_status='S' then 1 end) SrvErr,
        count( case when tran_type=1 and tran_test=0 then 1 end) Totals,
        count( case when tran_type=15 then 1 end) ChrBcks,
        count( case when tran_type=29 then 1 end) HiRskWrn,
        count( case when tran_type=26 then 1 end) CpyRqst,
        count( case when tran_type=21 then 1 end) ChrBckRvsl,
        count( case when tran_type=2 then 1 end) Refunds,
        count( case when tran_type=41 then 1 end) RefunChrBcks
from trans_details
where tran_time >= '&1' and tran_time < '&2'
group by extract(year from tran_time), extract(month from tran_time), extract(day from tran_time), merchant_id,store_id,card_type
having count(case when (tran_type in (1,15,29,26,21,2,41)) and tran_test=0 then 1 end) > 0
order by 1;
