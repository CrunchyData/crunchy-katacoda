In order to create a replica in PostgreSQL, a base backup of the current primary is used. We then start up that backup with a recovery.conf in place to tell it how to connect back to the primary. 

For the remainder of this scenario, and when you run any of these commands on your own systems, it is better to be the postgres system user, so let's switch to that now
```
sudo -iu postgres
```{{execute T1}}

The following is a typical pg_basebackup command use for this. Remember the password for our replica user is `password`. 
```
pg_basebackup -h 127.0.0.1 -U replica_user -D /var/lib/pgsql/11/replica -R -Xs -P -S training_replica -v
```{{execute T1}}

The different options for pg_basebackup can be reviewed in the documentation - https://www.postgresql.org/docs/current/app-pgbasebackup.html

The options we are using here are

 * `-h` - set the hostname where the primary database is running
 * `-U` - set the user to connect to the primary as. This should be the replication role that we set previously.
 * `-D` - set the destination of the data directory for the replica. If this folder does not exist, it will be created. If it already exists, it must be empty and should be owned by your postgres system user
 * `-R` - create a default recovery.conf file with the minimum settings necessary for it to connect back to the primary for streaming replication
 * `-Xs` - This option ensures that all the WAL files that are generated while the backup is run are also copied to the destination directory. These are necessary in order to start any backups created by pg_basebackup.
 * `-P` - Show the current progress of the basebackup while it's running. This can be handy for very large databases.
 * `-S` - Tell the backup to connect to the primary using the specified replication slot. This tells the primary to activate this slot and from this point forward, the primary will keep all WAL files that will be necessary for this replica to catch up and continue streaming.
 * `-v` - provide more verbose output.


