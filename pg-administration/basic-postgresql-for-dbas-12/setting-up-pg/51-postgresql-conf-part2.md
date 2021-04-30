
These last sections of this scenario are all explanation with no further commands to run. So to make it easier to read, you can enlarge this text section of the lesson by dragging the mid-bar to the right.

Some of these settings will require a restart of the database to change, so it is good to try and set these to your desired values when first setting up your clusters. The values given are what we would recommend for most common scenarios. EL7 does set some of our recommendations by default, but not all systems do.

`listen_addresses` - Sets the IP address(es) that PostgreSQL listens on. Defaults to localhost only for security. Recommend setting to server IP. `*` = all IPs. https://www.postgresql.org/docs/current/runtime-config-connection.html

`max_connections` - Controls the maximum number of connections allowed to the database. Affected by work_mem (see below). https://www.postgresql.org/docs/current/runtime-config-connection.html#GUC-MAX-CONNECTIONS

`shared_buffers` - Controls how much memory the server uses for shared memory buffers. 8GB is a good starting point, even with very high RAM availability. If it cannot be set that high, 25% of total memory is a good starting point (https://www.postgresql.org/docs/current/runtime-config-resource.html). 

`work_mem` - Specifies the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. 2-5MB is a good starting point. Note that individual queries can use multiple instances of this value, hence why it generally seems low. https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-WORK-MEM. The PostgreSQL Wiki has a great writeup on how all the memory settings relate to each other and how to better tune this setting - https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server

`maintenance_work_mem` - Specifies the max amount of memory to be used by maintenance operations such as vacuuming and index/constraint creation. 1GB is generally a good starting point and often the ideal setting in most situations. Can be adjusted on a per session basis to improve one-off maintenance task performance. https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAINTENANCE-WORK-MEM

`effective_cache_size` - Sets the query planner's assumption about the effective size of the disk cache that is available to a single query. 50% RAM is a good starting point, possibly higher if PostgreSQL is the only service running on the server. https://www.postgresql.org/docs/current/runtime-config-query.html#GUC-EFFECTIVE-CACHE-SIZE



