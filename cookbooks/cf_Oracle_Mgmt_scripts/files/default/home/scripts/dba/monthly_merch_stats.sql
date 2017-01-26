spool Jan.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-JAN-14' and '01-FEB-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;

spool Feb.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-FEB-14' and '01-MAR-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;

spool Mar.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-MAR-14' and '01-APR-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;

spool Apr.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-APR-14' and '01-MAY-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;
	
spool May.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-MAY-14' and '01-JUN-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;
	
spool Jun.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-JUN-14' and '01-JUL-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;
	
spool Jul.txt
select a.merchant_id, b.merchant_name,
    count( case when tran_type=1 and auth_status='D' then 1 end) Declines,
	count( case when tran_type=1 and auth_status='A' then 1 end) Auths,
	count( case when tran_type=1 and auth_status='V' then 1 end) ValidErr,
	count( case when tran_type=1 and auth_status='R' then 1 end) Declrefrl,
	count( case when tran_type=1 and auth_status='B' then 1 end) OnHold,
	count( case when tran_type=1 and auth_status='S' then 1 end) SrvErr,
	count( case when tran_type=1 then 1 end) Totals
	from trans_details a, merchants b 
	where tran_time between '01-JUL-14' and '01-AUG-14' and a.merchant_id=b.merchant_id
	group by a.merchant_id, b.merchant_name order by 3 desc;
spool off;
