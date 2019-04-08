## Configure pgbackrest

Make sure you are root, 

```
exit
```{{execute}}

```
vi /etc/pgbackrest.conf
```{{execute}}

```
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2

[demo]
pg1-path=/var/lib/pgsql/11/data
```

## Modify permissions
```
chmod 750 /var/lib/pgbackrest
chown postgres:postgres /var/lib/pgbackrest
```{{execute}}

## Postgresql.conf settings
```
vi /var/lib/pgsql/11/data/postgresql.conf
```{{execute}}

```
archive_command = 'pgbackrest --stanza=demo archive-push %p'
archive_mode = on
```

## Restart Postgres
```
systemctl restart postgresql-11
```{{execute}}

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

## Get information
```
sudo -u postgres pgbackrest info 
```{{execute}}