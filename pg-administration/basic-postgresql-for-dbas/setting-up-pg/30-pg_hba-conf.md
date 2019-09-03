
The pg_hba.conf file, by default located in the data directory, is how connection authentication is managed in PostgreSQL. This covers the incoming connections only, not specific object access within the database itself (the latter is covered via the GRANTs system).

Secure connections via SSL and third-party access management via GSSAPI/Certificate/etc is also managed via this file. The full capabilities of what can be done via this file can be found in the documentation - https://www.postgresql.org/docs/current/auth-pg-hba-conf.html

The file is always evaluated from the top down and as soon as a match is found, further evaluation is halted. So be careful with the ordering of entries to ensure the proper rules are evaluated in the desired order.

It is recommended to avoid the "trust" authentication method whenever possible since this allows unfettered access for the users that match. It is recommended to always at least require password authentication (`scram-sha-256`, `md5`). If passwordless logins are desired, it is recommended to use a `.pgpass` file to securely keep user credentials available on the database - https://www.postgresql.org/docs/current/libpq-pgpass.html

The example system in this scenario enables peer authentication by default. This means that any system user that has a matching database role can log in without requiring a password. Since the cluster was created by the `postgres` system user, a `postgres` role exists in the database. You can see the existing roles via `psql` by using the `\du` command
```
\du
```{{execute postgres_terminal}}
You can also see the current contents of the pg_hba.conf file from within the database if you are on at least PG10. 
```
SELECT * FROM pg_hba_file_rules;
```{{execute T2}}
Note that this shows the actual file's contents, not what may be active within the database. Putting pg_hba.conf changes in place requires reloading the database, which we will do shortly.

An example for adding an entry to allow a password protected connection for replication would be as follows:
```
host    replication    replica_user    192.168.1.201/32    md5
```
The first column controls the connection type, be it TCP, SSL, or local socket. `host` means it will be a TCP/IP based connection

The second column controls the databases this rule will apply to. `replication` refers to a special database that exists within PostgreSQL to allow streaming replication. Any database(s) can be listed here to control specific access. The special value `all` matches all valid databaes.

The third column controls which roles this rule will apply to. `replica_user` refers to a role with that name that was given the special REPLICATION privilege for this purpose. Again the special `all` value can be used here.

The fourth column specifies the client machine address(es) that this record matches. This can be a hostname, a CIDR formatted IP address range or certain special keywords covered in the documention. If hostnames are being used, ensure reverse name resolution is working properly and performant. Recommend using IP address ranges if possible.

The fifth column refers to the authentication method. Here `md5` refers to a hashed password method. There are many, many different methods possible and the above documentation link goes over all of them. The more recent method of `scram-sha-256` is highly recommended over `md5` if supported by the client.

Reloading the database can be done in two ways. While logged into the database, any superuser can call the `pg_reload_conf()` function
```
SELECT * FROM pg_reload_conf();
```{{execute T2}}
Or from the system command line, any users with access to control PostgreSQL via systemd can issue a reload. So on our original root terminal, issue the reload
```
sudo systemctl reload postgresql-11
```{{execute T1}}
If there are any errors encountered in the pg_hba.conf, the changes will not be applied. You can check the PostgreSQL logs for either a successful SIGHUP or any error messages
```
sudo bash -c "tail /var/lib/pgsql/11/data/log/postgresql-*.log"
```{{execute}}



