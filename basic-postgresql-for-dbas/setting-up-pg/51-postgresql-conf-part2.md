postgresql.conf Part 2
----------------------

These last sections of this scenario are all explanation and no futher commands to run. So to make it easier to read, you can enlarge this text section of the lesson by dragging the mid-bar to the right.

Some of these settings will require a restart of the database to change, so it is good to try and set these to your desired values when first setting up your clusters. The values given are what we would recommend for most common scenarios. And EL7 does set some of our recommendations by default, but not all systems do.

`listen_addresses` - Sets the IP address(es) that PostgreSQL listens on. Defaults to localhost only for security. Recommend setting to server IP. `*` = all IPs. https://www.postgresql.org/docs/current/runtime-config-connection.html

`max_connections` - Controls the maximum number of connections allowed to the database. Affected by work_mem (see below). https://www.postgresql.org/docs/current/runtime-config-connection.html#GUC-MAX-CONNECTIONS

`shared_buffers` - Controls how much memory the server uses for shared memory buffers. 8GB is a good starting point, even with very high availability. If it cannot be set that high, 25% of total memory is a good starting point. https://www.postgresql.org/docs/11/runtime-config-resource.html. Further information on tuning this setting can be found on this blog series: https://www.keithf4.com/a-small-database-does-not-mean-small-shared_buffers/ 

`work_mem` - Specifies the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. 2-5MB is a good starting point. Note that individual queries can use multiple instances of this value, hence why it generally seems low. https://www.postgresql.org/docs/11/runtime-config-resource.html#GUC-WORK-MEM. The PostgreSQL Wiki has a great writeup on how all the memory settings relate to each other and how to better tune this setting - https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server

`maintenance_work_mem` (1GB good starting point)

`wal_level` = replica

`effective_cache_size` (50% RAM good starting point)

`archive_mode` = on

`archive_command` = ‘/bin/true’

`archive_timeout` = 60

`max_wal_senders` = 10

`wal_keep_segments` = 30

`max_replication_slots` = 10

`hot_standby` = on (setting for replica)

`logging_collector` = on

`autovacuum_freeze_max_age` = 1000000000 (only set this high if monitoring for wraparound. So monitor for wraparound and set it this high.)

LINK TO ADVANCED SCENARIO THAT EXPLAINS XIDS/EXHAUSTION/WRAPAROUND
