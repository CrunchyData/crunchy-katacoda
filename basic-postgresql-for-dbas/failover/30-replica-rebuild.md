Once you've confirmed your old primary server is in a stable condition to be able to run PostgreSQL, or you are just doing a planned failover, you typically want to be able to now reuse that system as a replica to the new primary. The method outlined in Part 2 of this training could certainly be used to rebuild the replica, and is a perfectly valid option. The old data directory would have to be emptied first and a whole new pg_basebackup would need to be done. 

However, for very large databases, this could take quite a long time. A quicker method to rebuild the replica is possible using pgBackRest's `--delta` recovery option, which will be demonstrated here. For setup instructions on pgBackRest, see Part 4 of this training. This setup has already been done for this scenario.

First a new backup must be taken after the failover. Since we're running the primary & replica on the same system, the backrest setup is a little odd in that we've had to create a different stanza for the replica. For more normal pgBackRest setups where the primary & replica are different systems, please see the User Guide - https://pgbackrest.org/user-guide-index.html

```
sudo -Hiu postgres pgbackrest --stanza=new-primary backup
```{{execute T1}}

Now that new backup can be restored to the location of the old primary using the `--delta` option which will cause it to only have to copy over the files which have changed. For a very large database it still may take a bit of time for all the checksum comparisons of files to complete, but if this is done soon after the failover, it will take much, much less time than a full copy of all data files. Without the `--delta` option, the target of a pgBackRest restore must be an empty folder. 
```
pgbackrest restore --stanza=new-primary --db-path=/var/lib/pgsql/11/data --delta
```{{execute T1}}
Doing this restore with pgbackrest also creates a default `recovery.conf` file as well. By default this would only contain the `restore_command` that tells postgres how to use pgbackrest to replay the WAL files. But if you look in the /etc/pgbackrest.conf file that was prepared for this environment, some additional restore options were set for the stanzas. 
```
cat /etc/pgbackrest.conf
```{{execute T1}}
This causes any restores for those stanzas to automatically have these options also added to their recovery.conf file. This was prepared to allow any replicas that are created to use streaming replication with a specifically named replication slot.
```
cat /var/lib/pgsql/11/data/recovery.conf
```{{execute T1}}
Having this prepared ahead of time can greatly decrease the downtime encoutered during replica rebuilds.

The rebuilt replica can now be started and should connect as a streaming replica to the new primary. Again, since we're running this pair of systems on the same server, the port number needs to be updated on the new replica since it just copied the postgresql.conf from the current primary
```
sed -i "/port = 5444/c\port = 5432" /var/lib/pgsql/11/data/postgresql.conf
```{{execute T1}}

Since this is the instance that was managed by systemd before, the service method can be used.
```
systemctl start postgresql-11
```{{execute T1}}
```
tail /var/lib/pgsql/11/data/log/* | grep primary
```{{execute T1}}
```
psql
\x
SELECT * FROM pg_stat_replication;
```{{execute T1}}
```
SELECT * FROM pg_replication_slots;
```{{execute T1}}


