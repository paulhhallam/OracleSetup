set lin 200
set pagesize 999
select instance_name from v$instance;
SELECT ROUND(pga_target_for_estimate / 1048576) pga_target_mb,
       pga_target_factor * 100 pga_target_factor_pct,
       ROUND(estd_extra_bytes_rw / 1048576) estd_extra_mb_rw,
       estd_pga_cache_hit_percentage, estd_overalloc_count
FROM v$pga_target_advice
ORDER BY pga_target_factor;
select * from v$sga_target_advice
order by ESTD_DB_TIME_FACTOR DESC;
