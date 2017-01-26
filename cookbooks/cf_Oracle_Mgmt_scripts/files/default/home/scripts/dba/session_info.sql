set serveroutput on size 50000
DECLARE
  v_sid number;
  s sys.v_$session%ROWTYPE;
  p sys.v_$process%ROWTYPE;
BEGIN
  for i in(select sid,osuser,username,to_char(s.last_call_et/60/60, '9990.0')  from v$session s where SID in (&1))
loop
  select * into s from sys.v_$session where sid  = i.sid;
  select * into p from sys.v_$process where addr = s.paddr;
  dbms_output.put_line('=====================================================================');
  dbms_output.put_line('SID/Serial  : '|| s.sid||','||s.serial#);
  dbms_output.put_line('Foreground  : '|| 'PID: '||s.process||' - '||s.program);
  dbms_output.put_line('Shadow      : '|| 'PID: '||p.spid||' - '||p.program);
  dbms_output.put_line('Terminal    : '|| s.terminal || '/ ' || p.terminal);
  dbms_output.put_line('OS User     : '|| s.osuser||' on '||s.machine);
  dbms_output.put_line('Ora User    : '|| s.username);
  dbms_output.put_line('Status Flags: '|| s.status||' '||s.server||' '||s.type);
  dbms_output.put_line('Tran Active : '|| nvl(s.taddr, 'NONE'));
  dbms_output.put_line('Login Time  : '|| to_char(s.logon_time, 'Dy HH24:MI:SS'));
  dbms_output.put_line('Last Call   : '|| to_char(sysdate-(s.last_call_et/60/60/24), 'Dy HH24:MI:SS') || ' - ' || to_char(s.last_call_et/60, '99999.0') || ' min');
  dbms_output.put_line('Lock/ Latch : '|| nvl(s.lockwait, 'NONE')||'/ '||nvl(p.latchwait, 'NONE'));
  dbms_output.put_line('Latch Spin  : '|| nvl(p.latchspin, 'NONE'));
  dbms_output.put_line('SQL Hash    : '|| s.sql_hash_value);

  dbms_output.put_line('Current SQL statement:');
  for c1 in ( select * from sys.v_$sqltext
              where HASH_VALUE = s.sql_hash_value order by piece) loop
    dbms_output.put_line(chr(9)||c1.sql_text);
  end loop;

  dbms_output.put_line('Previous SQL statement:');
  for c1 in ( select * from sys.v_$sqltext
              where HASH_VALUE = s.prev_hash_value order by piece) loop
    dbms_output.put_line(chr(9)||c1.sql_text);
  end loop;

  dbms_output.put_line('Session Waits:');
  for c1 in ( select * from sys.v_$session_wait where sid = s.sid) loop
    dbms_output.put_line(chr(9)||c1.state||': '||c1.event);
  end loop;

--  dbms_output.put_line('Connect Info:');
--  for c1 in ( select * from sys.v_$session_connect_info where sid = s.sid) loop
--   dbms_output.put_line(chr(9)||': '||c1.network_service_banner);
--  end loop;
  end loop;
  dbms_output.put_line('=====================================================================');
END;
/
