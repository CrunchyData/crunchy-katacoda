First the roles must be created so that any database privileges can be properly granted back when the database itself is restored. Since the global dump file is just plain sql, it can be fed directly to the `psql` command as an input file.
```
psql -h localhost -p 5888 -d postgres -f /home/training/globals.sql -a
```{{execute T1}}
Once that is complete, the database itself can now be restored using `pg_restore`. 

https://www.postgresql.org/docs/current/app-pgrestore.html

It can be restored into any already existing database by just passing it via the `-d` option. So first create the database by logging in as a role that has that privilege. You can use the `-c` option to `psql` to pass in any SQL commands you'd like to run.
```
psql -h localhost -p 5888 -U postgres -c "CREATE DATABASE training"
```{{execute T1}}
Then tell `pg_restore` which database to restore into using the `-d` option
```
pg_restore -h localhost -p 5888 -U postgres -d training -v /home/training/training.pgr
```{{execute T1}}
Only `pg_restore` can restore a binary dump file back into postgres. The advantage of the binary dump format is that the restore can be done in parallel, with each process restoring a table. Also, if only 1 or a few tables need to be restored, those can be given using the `-t` option, instead of having to restore the entire database.

Connect to the new database running on the new port to see that the roles and tables have been restored. Since we're running in a non-default location, we also have to tell psql to connect via tcp by passing a hostname. Otherwise it tries to look for the local socket in a location that isn't used in this case.
```
psql -d training -p 5888 -h localhost
```{{execute T1}}
```
\du
```{{execute T1}}
```
\dt
```{{execute T1}}

The major advantage of using `pg_dump` for backups is that they are much smaller due to compression and only containing the definitions of indexes. Also the filtering of specific objects can make data recovery in an emergency much quicker than having to restore an entire backup. 

The disadvantages come into play when regular, full backups of the database are needed, or restoration of the entire database. Incremental backups are not possibly and during restoration, all indexes and constraints must be rebuilt and verified. This means a full restore can take an extremely long time. In that case, file-based backups are a much better option and the next scenarios will review some options for doing this.
