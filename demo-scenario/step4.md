## Configure pgbackrest
```
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2

[demo]
pg1-path=/var/lib/pgsql/11/data
```

## Modify permissions
```
sudo chmod 750 /var/lib/pgbackrest
sudo chown postgres:postgres /var/lib/pgbackrest
```

## Postgresql.conf settings
```
archive_command = 'pgbackrest --stanza=demo archive-push %p'
archive_mode = on
listen_addresses = '*'
log_line_prefix = ''
max_wal_senders = 3
wal_level = replica
```

## Restart Postgres
systemctl restart postgresql-11

## Create the stanza
```
sudo -u postgres pgbackrest --stanza=demo --log-level-console=info stanza-create
```{{execute}}

## Check the config
```
sudo -u postgres pgbackrest --stanza=demo --log-level-console=info check
```{{execute}}

## Backup the cluster
```
sudo -u postgres pgbackrest --stanza=demo \
       --log-level-console=info backup
```{{execute}}