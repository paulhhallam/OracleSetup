declare
l_job_out integer;
l_what dba_jobs.what%type;
l_cpus_to_hog CONSTANT integer := 16;
l_loop_count varchar2(10) := '5000000000'; begin

for l_job in 1..l_cpus_to_hog loop

dbms_job.submit(
job => l_job_out, what => 'declare a number := 1; begin for i in 1..'||l_loop_count||' loop a := ( a + i )/11; end loop; end;');
commit;
dbms_output.put_line( 'job - '|| l_job_out );
select what into l_what from dba_jobs where job = l_job_out;
dbms_output.put_line( 'what - '|| l_what );
end loop;
end;
/
