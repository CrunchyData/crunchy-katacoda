## PITR

## Create a table with important data
```
sudo -iu postgres 
psql davec -c "begin; \
       create table important_table (message text); \
       insert into important_table values ('Important Data'); \
       commit; \
       select * from important_table;"
```{{execute}} 


## Create a restore point to use to restore to
```
psql -Atc "select pg_create_restore_point('before_drop')"
```{{execute}}

## Drop the important table
```
psql davec -c "begin; \
       drop table important_table; \
       commit; \
       select * from important_table;"
exit
```{{execute}}

## Stop the database
```
systemctl stop postgresql-11
```{{execute}}

## Restore the database to the point before the drop note
we have to use the current timeline in order to get the data back

## We can confirm that the timeline is in fact 2 using the function
`pg_control_checkpoint()`

```
sudo -u postgres psql davec -x -c "select * from pg_control_checkpoint()"
```

```
sudo -iu postgres 
pgbackrest --stanza=demo --delta \
       --type=name "--target=before_drop" \
       --target-action=promote \
       --target-timeline=2 restore
exit

cat /var/lib/pgsql/11/data/recovery.conf
```{{execute}}

## Start the database
```
systemctl start postgresql-11
```{{execute}}

## Check the table is there
```
sudo -u postgres psql davec -c "select * from important_table"
```{{execute}}