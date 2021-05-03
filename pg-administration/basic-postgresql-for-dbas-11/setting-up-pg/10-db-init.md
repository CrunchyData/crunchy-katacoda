With the packages installed, the first thing we need to do is to initialize the PostgreSQL cluster. CentOS does not do this for you automatically, but does provide a script (`/usr/pgsql-11/bin/postgresql-11-setup`) to set up the default instance for you that will be managed by systemd.

To run the script, execute the following statement:
```
sudo PGSETUP_INITDB_OPTIONS="--data-checksums" /usr/pgsql-11/bin/postgresql-11-setup initdb
```{{execute T1}}

Passing the `initdb` command to the script tells it to initialize the PostgreSQL cluster. We also pass an option to the initdb command in order to enable checksums on our cluster. This feature is highly recommended to enable on all new clusters. Checksums on data pages help to detect corruption by the I/O system that would otherwise be silent. It can currently only be set on database initialization but work is underway to allow enabling it on existing database clusters. https://www.postgresql.org/docs/current/app-initdb.html#APP-INITDB-DATA-CHECKSUMS

Next we enable the service via systemd
```
sudo systemctl enable postgresql-11
```{{execute T1}}

And now we start the database via systemd
```
sudo systemctl start postgresql-11
```{{execute T1}}

After starting a service it's always good to check its status
```
systemctl status postgresql-11
```{{execute T1}}

If you encounter any issues, you can check the syslog for any errors related to systemd starting the service (`/var/log/messages`) or check the PostgreSQL logs as well (`/var/lib/pgsql/##/data/log`) where ## is the major version of PostgreSQL, e.g. 11, 10, 96, etc).

Note that prior to PG10, the log directory was called `pg_log`.
