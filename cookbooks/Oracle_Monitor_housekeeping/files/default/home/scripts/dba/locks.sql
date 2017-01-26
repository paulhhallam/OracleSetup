set pagesize 200
set linesize 150
column module format a35
SELECT gvh.inst_id Locking_Inst, gvh.sid Locking_Sid, gvs.serial# Locking_Serial,
       gvs.status Status, gvs.module Module, gvw.inst_id Waiting_Inst, gvw.sid Waiter_Sid,
       decode(gvh.type, 'MR', 'Media_recovery',
                        'RT', 'Redo_thread',
                        'UN', 'User_name',
                        'TX', 'Transaction',
                        'TM', 'Dml',
                        'UL', 'PLSQL User_lock',
                        'DX', 'Distrted_Transaxion',
                        'CF', 'Control_file',
                        'IS', 'Instance_state',
                        'FS', 'File_set',
                        'IR', 'Instance_recovery',
                        'ST', 'Diskspace Transaction',
                        'IV', 'Libcache_invalidation',
                        'LS', 'LogStaartORswitch',
                        'RW', 'Row_wait',
                        'SQ', 'Sequence_no',
                        'TE', 'Extend_table',
                        'TT', 'Temp_table',
                              'Nothing-') Waiter_Lock_Type,
       decode(gvw.request, 0, 'None',
                           1, 'NoLock',
                           2, 'Row-Share',
                           3, 'Row-Exclusive',
                           4, 'Share-Table',
                           5, 'Share-Row-Exclusive',
                           6, 'Exclusive',
                              'Nothing-') Waiter_Mode_Req ,
       'alter system kill session '|| '''' || gvh.sid || ',' || gvs.serial# || ''';' "Kill_Command"
FROM gv$lock gvh, gv$lock gvw, gv$session gvs
WHERE (gvh.id1, gvh.id2) in (
           SELECT id1, id2 FROM gv$lock WHERE request=0
                INTERSECT
           SELECT id1, id2 FROM gv$lock WHERE lmode=0)
  AND gvh.id1=gvw.id1
  AND gvh.id2=gvw.id2
  AND gvh.request=0
  AND gvw.lmode=0
  AND gvh.sid=gvs.sid
  AND gvh.inst_id=gvs.inst_id;
