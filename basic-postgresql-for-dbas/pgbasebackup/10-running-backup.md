The pg_dump/restore commands are useful for getting logical dumps of the database schema and its data out. But for large databass, dumps are not very practical for typical backup requirements. Especially from the point of a full database recovery since all indexes and constraints have to be rebuilt, taking quite a long time.

The `pg_basebackup` command can provide a complete, filesystem-based snapshot of the entire database cluster. It was already used in in the earlier `Replication` scenario of this training session to create the replica. It can also be used in a very similar manner to provide a compressed backup. And while pg_dump could be configured to only dump specific objects, `pg_basebackup` is always a complete copy of the entire database as of the time that the backup stops running.

https://www.postgresql.org/docs/current/app-pgbasebackup.html

CentOS automatically makes a location for backups in `/var/lib/pgsql/11/backups` where the postgres user has access, so that will be used here. It's also good to have a non-superuser role that can be used to connect to the database and run these backups. This role must be given the REPLICATION property in order to be able to run `pg_basebackup`. You can make a dedicated role just for backups, but in this case we're just going to use the `replica_user` role we created back in a previous scenario. Refer to the `Replication` scenario of this training if you want to see how to create these roles and set the pg_hba.conf appropriately.  If asked, the password is `password`.
Run the `pg_basebackup` command to create a compressed backup of our cluster
```
sudo -Hiu postgres pg_basebackup -h 127.0.0.1 -U replica_user -D /var/lib/pgsql/11/backups -Ft -z -Xs -P -v
```{{execute T1}}
The `-h` option here isn't really required but it's used in the example to show that you can do your backups across a network connection as well as locally. 

`-D` provides the destination for the backup to be written

`-Ft` tells it to tar the backup up into fewer files. There will be one file created for the base cluster, one file for any WAL files that are generated during the backup run, and additional files for any separate tablespaces that may exist in the cluster.

`-z` tells it to compress the tar file(s)

`-P` tells it to give a progress meter for how far along the backup is in real time

`-v` has it provide a more verbose output

The `-X` option requires a bit more explanation. `-Xs (--wal-method=stream)` is the default in PG10+, so generally isn't needed anymore. But if you're running an older version it is highly recommended to set the method to `stream`. The other option, `-Xf (fetch)` will only provide a consistent backup if all WAL generated during backup run exist at the end of the backup. For large databases this is often not the case, unless `wal_keep_segments` is set very high, so you won't get a valid backup using this method. -Xs creates another streaming replication connection back to the primary to collect the WAL into the backup as it is generated. So this does require one additional wal sender being available on the primary (max_wal_senders), but it is highly recommended configuring your system so this is possible. The default value for wal senders in PG10+ is now `10` so generally it should just work.

Unlike when `pg_basebackup` is used to create a replica, the `-R` option is not necessary to create a recovery.conf.


