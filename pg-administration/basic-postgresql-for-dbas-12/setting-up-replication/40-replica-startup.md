Typically you would use the relevant service setup (systemd, init.d, etc) to start up your replica at this point, but since we're running on the same system, we're going to use the `pg_ctl` binary directly. This is what most services use under the hood to control PostgreSQL. It's not in the default path on RHEL based systems, so its full path must always be used.

Next we can use the `pg_ctl` command to start up our replica. Further details on this binary's options can be found here - https://www.postgresql.org/docs/current/app-pg-ctl.html
```
/usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/replica start
```{{execute T1}}
To see if things started up ok, check the replica's logs located in `/var/lib/pgsql/12/replica/log`. The line containing what we're looking for is contained in the grep statement below. 
```
grep "started streaming WAL from primary" /var/lib/pgsql/12/replica/log/*
```{{execute T1}}

If there are no errors in the log and the above line shows up successfully, then the replica has connected to the primary and streaming replication is working!

Further things you can do to check replication status are contained in the following system catalogs that should be queried from the primary:
```
psql
```{{execute T1}}
The pg_stat_replication view - https://www.postgresql.org/docs/current/monitoring-stats.html#PG-STAT-REPLICATION-VIEW
```
SELECT * FROM pg_stat_replication;
```{{execute T1}}
The pg_replication_slots view - https://www.postgresql.org/docs/current/view-pg-replication-slots.html
```
SELECT * FROM pg_replication_slots;
```{{execute T1}}
Or you can simply create a table on your primary then check and see if it shows up on your replica
```
CREATE TABLE testing (
    id bigint primary key, 
    stuff text, 
    inserted_at timestamptz default now());
```{{execute T1}}

```
INSERT INTO testing (id) values (generate_series(1,10));
```{{execute T1}}
Now disconnect from the primary
```
\q
```{{execute T1}}
and connect to the replica running on the alternate port
```
psql -p 5444
```{{execute T1}}
```
SELECT * FROM testing;
```{{execute T1}}
Another query that can be run to see if you are connected to a primary or replica is below. It will be true on a replica, and false on a primary.
```
SELECT pg_is_in_recovery();

```{{execute T1}}
