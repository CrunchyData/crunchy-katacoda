`pg_basebackup` is included with PostgreSQL and is great for many filesystem backup scenarios. However, it can be lacking in many advanced features that enterprise backup solutions require; incrementals & differentials, retention management, parallelism, and more. pgBackRest is a third-party tool that aims to provide these advanced features and much more!

pgBackrest is available in the PGDG Yum repositories. These have already been set up in this scenario, so it's just a matter of installing the package

```
sudo yum install -y pgbackrest
```{{execute T1}}
Next some settings in the postgresql.conf must be updated to ensure WAL archiving is working. `archive_mode` must be turned on and the `archive_command` must be set to use pgBackRest's `archive-push` command. A stanza name for the pgBackRest repo must also be given and that will be set up in the next step. Since we're changing these values on a running system, the ALTER SYSTEM command can be used
```
psql -c "ALTER SYSTEM SET archive_mode = 'on'"
```{{execute T1}}
```
psql -c "ALTER SYSTEM SET archive_command = 'pgbackrest archive-push --stanza=main %p'"
```{{execute T1}}
Archive mode isn't typically turned on by default and changing this setting requires restarting the database to enable it
```
sudo systemctl restart postgresql-11
```{{execute T1}}
You may see errors in the postgresql logs about the archive_command failing. This is normal and should resolve itself once the pgBackRest repository is set up. Do note that until the errors subside, the database will retain all WAL files generated in the `pg_wal` folder until it succeeds. In the case where the pgBackRest repo may not be available for an extended period of time, the easiest thing to do is to set `archive_command = '/bin/true'` until then. The command itself only requires a reload of the database to change, so that allows you to at least enable `archive_mode` until it's ready.

Next is configuring pgBackRest itself.
