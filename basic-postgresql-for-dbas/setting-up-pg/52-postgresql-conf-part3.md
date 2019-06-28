postgresql.conf Part 3
----------------------


The rest of these settings all only require a reload to change

`max_wal_size` = 1GB (default; hitting this forces checkpoint)

`min_wal_size` = 80MB (default; WAL kept for recycling)

`checkpoint_timeout` = 5min (default; good starting point)

`checkpoint_completion_target` = 0.9

`log_filename` = `'postgresql-%Y-%m-%d_%H%M%S'`

`log_min_duration_statement` = 5000ms (beware setting too low. can fill logs fast)

`log_connections` = on

`log_disconnections` = on

`log_line_prefix` = '%m [%r] [%p]: [l-%l] user=%u,db=%d,e=%e '
    %x & %v can be good for transaction tracking

`log_temp_files` = 4096 (kilobytes; good starting point = work_mem)

`log_lock_waits` = on

`autovacuum_vacuum_threshold` = 500 (default too aggressive)

`autovacuum_analyze_threshold` = 500 (default too aggressive)

`autovacuum_vacuum_scale_factor` = 0.1 (default too mild)

`autovacuum_analyze_scale_factor` = 0.05 (default too mild)

