
`wal_level` = replica

`archive_mode` = on

`archive_command` = ‘/bin/true’

`archive_timeout` = 60

`max_wal_senders` = 10

`wal_keep_segments` = 30

`max_replication_slots` = 10

`max_wal_size` = 1GB (default; hitting this forces checkpoint)

`min_wal_size` = 80MB (default; WAL kept for recycling)

`checkpoint_timeout` = 5min (default; good starting point)

`checkpoint_completion_target` = 0.9





