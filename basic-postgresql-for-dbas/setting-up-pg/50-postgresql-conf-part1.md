postgresql.conf Part 1
----------------------
The postgresql.conf file is the primary location of all configuration settings in PostgreSQL. By default it is located at the top level of the data directory. This last section is going to go over the primary settings that you may need to be worried about when first setting up a PostgreSQL cluster. There are many, many more settings and their importance is determined by your particular use-cases.

Several of the settings in postgresql.conf require a restart while others only require a reload. One of the easiest ways to always be able to quickly see if a setting requires a restart or not is to check the `pg_settings` catalog, particularly the `context` column.

Now that we have our own user we can log into the database with, we'll continue running SQL commands there
```
SELECT name, setting, context FROM pg_settings WHERE name IN ('shared_buffers', 'work_mem', 'archive_mode', 'archive_command');
```{{execute T1}}

We can also see the current value of any setting here as well, similarly how we used the `SHOW` command earlier. The meanings of the `context` column can be found in the documentation - https://www.postgresql.org/docs/11/view-pg-settings.html. For the settings we checked above, we can see that `archive_command` and `work_mem` only require a reload while `archive_mode` and `shared_buffers` require a restart. And `work_mem` is even more unique in that each individual role can change that setting for themselves for the duration of their session.

If you need to restart the database, the best way to do that in a production environment on EL7 is with systemd
```
\q
sudo systemctl restart postgresql-11
```{{execute T1}}


Let's move on to reviewing some important settings. We'll be briefly going over each setting but also provide a link to its documentation for more information.
