Since we're running our replica on the same system as our primary, we'll have to change the port that it runs on. You normally wouldn't need to do this when the replica is running on a separate system. You can either do this manually in the demo terminal, or run the following `sed` command. Change it to run on port `5444`.

```
sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/12/replica/postgresql.conf
```{{execute T1}}
A `standby.signal` file should have been created for us in the target data directory. And the minimal replica settings needed should have been added to the `postgresql.auto.conf` file. This is an override file for the `postgresql.conf` file and any settings here will take precedence. Let's take a look at its contents:
```
cat /var/lib/pgsql/12/replica/postgresql.auto.conf
```{{execute T1}}

 * `primary_conninfo` - the connection string to tell the replica how to connect to its primary
 * `primary_slot_name` - the replication slot to use (if used)

Further options for replication can be found in the documentation and we will be covering some of these in future scenarios: 

- https://www.postgresql.org/docs/12/runtime-config-replication.html#RUNTIME-CONFIG-REPLICATION-STANDBY
- https://www.postgresql.org/docs/12/runtime-config-wal.html#RUNTIME-CONFIG-WAL-ARCHIVE-RECOVERY
- https://www.postgresql.org/docs/12/runtime-config-wal.html#RUNTIME-CONFIG-WAL-RECOVERY-TARGET

