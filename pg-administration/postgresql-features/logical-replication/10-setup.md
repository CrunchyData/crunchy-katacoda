For logical replication to work, the `wal_level` setting must be set to `logical` so that the necessary data is added to the WAL stream. Note that if you're changing an existing database to provide logical replication, you may see a slight increase in overall WAL traffic. Also, the `max_replication_slots` setting should be set to at least the number of replicas + subscribers that are expected. And the `max_wal_senders` setting should be set slightly higher than that to allow for other replication needs such as pg_basebackup.
```
psql -c "ALTER SYSTEM SET wal_level = 'logical'"
psql -c "SHOW max_replication_slots"
psql -c "SHOW max_wal_senders"

```{{execute T1}}
Note that all settings mentioned above require a restart to put into affect when changed
```
systemctl restart postgresql-11
```{{execute T1}}
Just like with standard replication, a role with the REPLICATION property must exist for the subscribers to connect with. The `replica_user` role has already been created on the demo database along with the proper pg_hba.conf entry to allow secure password authentication. Note that unlike regular replication, you must set it to allow the replica_user to connect to the database that contains the publisher, not the special `replication` database.
```
psql -c "\du" 
```{{execute T1}}
```
cat /var/lib/pgsql/11/data/pg_hba.conf
```{{execute T1}}


