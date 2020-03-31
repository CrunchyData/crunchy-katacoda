With the primary confirmed to be down and not able to come back up on its own anymore, the replica can now be promoted to be the new primary. And that's as easy as running the following command as the postgres system user.
```
sudo -Hiu postgres /usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/replica promote
```{{execute T1}}
If you're doing a planned failover, this should be fairly quick and your replica will be turned into the primary within a second or 2. If this is an unplanned failover, there may be some WAL files that still need to be replayed before the database is in a consistent state to come up as a standalone system. Monitor the replica's log files to see its progress. If the promotion was successful, messages similar to the following should be in the logs
```
2019-07-23 23:20:40.088 UTC [1167] LOG:  received promote request
2019-07-23 23:20:40.088 UTC [1167] LOG:  redo done at 0/4000028
2019-07-23 23:20:40.094 UTC [1167] LOG:  selected new timeline ID: 2
2019-07-23 23:20:40.205 UTC [1167] LOG:  archive recovery complete
2019-07-23 23:20:40.246 UTC [1165] LOG:  database system is ready to accept connections
```
Whenever a PostgreSQL database is promoted from a replica to a primary, an internal number called the `timeline` is incremented. You can also see this number increment reflected in the filenames of the WAL files. Also, the `standby.signal` file is removed for you.

Also, replication slots are currently not preserved during a failover, so that will have to be created again on the new primary if desired.
```
psql -p 5444 -c "SELECT * FROM pg_create_physical_replication_slot('training_replica')"
```{{execute T1}}
