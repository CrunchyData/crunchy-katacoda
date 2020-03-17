`logging_collector` - Enables the logging collector background process that captures log messages sent to stderr and redirects them into log files. The RHEL provided instance enables this by default, but databases initialized directly with `initdb` will typically not have this enabled by default. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOGGING-COLLECTOR

`log_filename` - When `logging_collector` is enabled, sets the filename format of the files it creates. Recommended value is `'postgresql-%Y-%m-%d_%H%M%S'` to avoid log rotation from overwriting old files with matching names. RHEL defaults to day-of-the-week naming, which means when the same day comes again the next week, it is overwritten, giving you 7 days of log history by default. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-FILENAME

`log_min_duration_statement` - Causes any queries that took longer than the given number of milliseconds to run to be logged, along with the time duration. Beware setting too low since that can greatly increase logging size. Recommend setting it to log queries that take longer than the expected maximum query time. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-MIN-DURATION-STATEMENT. Along with the `auto_explain` contrib module this is a very effective slow query logging method. https://www.postgresql.org/docs/current/auto-explain.html

`log_connections` - Causes each attempted connection to the server to be logged, as well as successful completion of client authentication. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-CONNECTIONS

`log_disconnections` - Causes session terminations to be logged, plus the duration of the session. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-DISCONNECTIONS

`log_line_prefix` - This is a printf-style string that is output at the beginning of each log line. Default is very minimal, so recommend reviewing to ensure critical session data is getting logged. Recommended value to get started is `'%m [%r] [%p]: [l-%l] user=%u,db=%d,e=%e '`, which will cause entries similar to this:
```
2019-07-25 14:22:40.299 EDT [[local]] [63933]: [l-1] user=keith,db=keith,e=00000 LOG:  duration: 1.505 ms  statement: select * from pg_stat_activity;
```
https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-LINE-PREFIX

`log_temp_files` - Logs any temporary files that exceed the given value in kilobytes. A good starting value for this is the `work_mem` value to catch queries that exceed that and spill to disk for query operations. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-TEMP-FILES

`log_lock_waits` - Controls whether a log message is produced when a session waits longer than deadlock_timeout to acquire a lock. Can potentially cause much larger log files, but very useful when trying to narrow down performance issues related to locking. https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-LOCK-WAITS
