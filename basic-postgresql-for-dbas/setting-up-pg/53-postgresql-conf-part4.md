postgresql.conf Part 4 - Logging
--------------------------------

`logging_collector` = on

`log_filename` = `'postgresql-%Y-%m-%d_%H%M%S'`

`log_min_duration_statement` = 5000ms (beware setting too low. can fill logs fast)

`log_connections` = on

`log_disconnections` = on

`log_line_prefix` = '%m [%r] [%p]: [l-%l] user=%u,db=%d,e=%e '
    %x & %v can be good for transaction tracking

`log_temp_files` = 4096 (kilobytes; good starting point = work_mem)

`log_lock_waits` = on




