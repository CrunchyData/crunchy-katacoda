## Replication

First step create, use pgbackup to create a replica

```
sudo -iu postgres
pg_basebackup -D 11/data1 -X stream -R

```{{execute}}

We now need to edit postgresql.conf to change the port the replica is listening on

search for #5432 and change it to 5433

```
vi 11/data1/postgresql.conf
```{{execute}}

# Start the replica

```
/usr/pgsql-11/bin/pg_ctl -D 11/data1 -l logfile1 start
cat logfile
```{{execute}}

# Check to make sure we can connect
```
psql -p 5433 davec
```{{execute}}