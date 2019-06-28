PostgreSQL Host Based Authentication (pg_hba.conf)
--------------------------------------------------

The pg_hba.conf file, by default located in the data directory, is how connection authentication is managed in PostgreSQL. This covers the incoming connections only, not specific object access within the database itself (the latter is covered via the GRANTs system).

Secure connections via SSL and third-party access management via LDAP/Kerberos/etc is also managed via this file. The full capabilities of what can be done via this file can be found in the documentation - https://www.postgresql.org/docs/current/auth-pg-hba-conf.html

The file is always evaluated from the top down and as soon as a match is found, further evaluation is halted. So be careful with the ordering of entries to ensure the proper rules are evaluated in the desired order.

It is recommended to avoid the "trust" authentication method whenever possible since this allows unfettered access for the users that match. It is recommended to always at least require password authentication (`scram-sha-256`, `md5`). If passwordless logins are desired, it is recommended to use a `.pgpass` file to securely keep user credentials available on the database - https://www.postgresql.org/docs/current/libpq-pgpass.html

The example system in this scenario enables peer authentication by default. This means that any system user that has a matching database role can log in without requiring a password. Since the cluster was created by the `postgres` system user, a `postgres` role exists in the database. You can see the existing roles via `psql` by using the `\du` command
```
\du
```{{execute}}
You can also see the current contents of the pg_hba.conf file from within the database if you are on at least PG10. 
```
SELECT * FROM pg_hba_file_rules;
```{{execute}}
Note that this shows the actual file's contents, not what may be active within the database. Putting pg_hba.conf changes in place requires reloading the database, which we will do shortly.

An example for adding an entry to allow a password protected connection for replication would be as follows:
```
host    replication    replication    192.168.1.201/32    md5
```
`host` means it will be a TCP/IP based connection

The second column `replication` refers to a special database that exists within PostgreSQL to allow streaming replication

The third column `replication` refers to a role with that name that was given the special REPLICATION privilege for this purpose.

The fourth column can be any CIDR formatted IP address location. Any IP addresses that match this will be allowed to connect as long as the database, role & method also match

The fifth column refers to the authentication method. Here `md5` refers to a hashed password method.

Reloading the database can be done in two ways. While logged into the database, any superuser can call the `pg_reload_conf()` function
```
SELECT * FROM pg_reload_conf();
```{{execute}}
Or from the system command line, any users with access to control PostgreSQL via systemd can issue a reload. First we'll log out of psql with the `\q` command, return to being root, then issue the reload
```
\q
exit
systemctl reload postgresql-11
```{{execute}}
If there are any errors encountered in the pg_hba.conf, the changes will not be applied. You can check the PostgreSQL logs for either a successful SIGHUP or any error messages
```
tail -f /var/lib/pgsql/11/data/log/*.log
```{{execute}}



