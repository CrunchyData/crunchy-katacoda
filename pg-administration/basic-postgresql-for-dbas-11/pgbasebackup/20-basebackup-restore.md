Restoring a pg_basebackup is extremely easy. Just copy the result of the command to the desired location, extracting from tar if needed, and that's it! Note that the restores are all or nothing, so you always get the entire cluster back. But since it is just copying files from one place to another, the restore time is only bound by filesystem IO (and possibly CPU if decompressing) and no indexes or constraints need to be rebuilt. If you do require the ability to restore specific objects, there is nothing wrong with running both filesystem backups and dumps for your backup solution.

For this scenario we will just copy it to another location that the `postgres` system user can access to make it easier.
```
sudo -Hiu postgres mkdir /var/lib/pgsql/11/mydb
sudo -Hiu postgres chmod 700 /var/lib/pgsql/11/mydb
```{{execute T1}}
Use tar to extract the backup. Always do the base extraction first, followed by the WAL files then any tablespaces that may have been in use. 
```
sudo -Hiu postgres tar xvzf /var/lib/pgsql/11/backups/base.tar.gz -C /var/lib/pgsql/11/mydb
```{{execute T1}}
Note the target location of the WAL extraction is the `pg_wal` folder inside the data directory (this was `pg_xlog` in versions earlier than 10).
```
sudo -Hiu postgres tar xvzf /var/lib/pgsql/11/backups/pg_wal.tar.gz -C /var/lib/pgsql/11/mydb/pg_wal
```{{execute T1}}
We can immediately start this database up if desired then as well. Just make sure to change the port number since we already have a cluster running on the default port. Another ***very important*** thing to do if starting up a filesystem backup, if not overwriting your existing database, is to disable WAL archiving so it doesn't corrupt any existing WAL file repositories (set `archive_mode` to `off` or `archive_command` to `/bin/true` before startup).
```
sudo sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/11/mydb/postgresql.conf
```{{execute T1}}
```
sudo sed -i "/archive_command/c\archive_command = '/bin/true'" /var/lib/pgsql/11/mydb/postgresql.conf
```{{execute T1}}
Once that's done, we can just use `pg_ctl` to start it up
```
sudo -Hiu postgres /usr/pgsql-11/bin/pg_ctl start -D /var/lib/pgsql/11/mydb
```{{execute T1}}
```
psql -p 5444
```{{execute T1}}
