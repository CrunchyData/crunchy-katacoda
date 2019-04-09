## Restore a backup

First lets break the current backup

```
systemctl stop postgresql-11
rm -f /var/lib/pgsql/11/data/global/pg_control
systemctl start postgresql-11
```{{execute}}

This should respond with
```
Job for postgresql-11.service failed because the control process exited with error code. See "systemctl status postgresql-11.service" and "journalctl -xe" for details.
```

As the cluster is now corrupt due to removing the pg_control file.

To restore a backup of the PostgreSQL cluster run pgBackRest with the restore command. The cluster needs to be stopped (in this case it is already stopped) and all files must be removed from the PostgreSQL data directory.

```
sudo -u postgres find /var/lib/pgsql/11/data -mindepth 1 -delete
```{{execute}}
```
Note this will throw an error, but it did delete the directory
```

# Now restore the backup

```
chown postgres /var/log/pgbackrest
sudo -u postgres pgbackrest --stanza=demo --log-level-console=info restore
systemctl start postgresql-11
```{{execute}}

# Check to make sure we can connect
```
sudo -u postgres psql davec
```{{execute}}