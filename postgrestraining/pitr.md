## PITR

## Create a table with important data
```
sudo -u postgres psql davec -c "begin; \
       create table important_table (message text); \
       insert into important_table values ('Important Data'); \
       commit; \
       select * from important_table;"
```{{execute}} 


## Record the time for the restore
```
sudo -u postgres psql -Atc "select current_timestamp"
```{{execute}}

## Drop the important table
```
sudo -u postgres psql davec -c "begin; \
       drop table important_table; \
       commit; \
       select * from important_table;"
```{{execute}}

## Stop the database
```
systemctl stop postgresql-11
```{{execute}}

## Restore the database to the point before the drop
```
sudo -u postgres pgbackrest --stanza=demo --delta \
       --type=time "--target=<time from previous step>" \
       --target-action=promote restore
```
```
cat /var/lib/pgsql/11/data/recovery.conf
```{{execute}}

## Start the database and check the table is there
```
systemctl start postgresql-11
sudo -u postgres psql davec -c "select * from important_table"
```{{execute}}

