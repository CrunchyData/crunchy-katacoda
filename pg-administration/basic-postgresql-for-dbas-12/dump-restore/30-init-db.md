We'll now be restoring both of the dumps that were created to a brand new database that will be created in the `training` user's home directory. You'll notice that none of the commands we run require sudo. Any user with access to the postgres binaries can manage a full database cluster in their home directory!

First create a folder to contain a new database instance that the dumps will be restored to. PostgreSQL also requires that this folder not be world accessible.
```
mkdir /home/training/mydb
chmod 700 /home/training/mydb
```{{execute T1}}
The following command will initialize a brand new instance in this new directory
```
/usr/pgsql-12/bin/initdb --data-checksums -D /home/training/mydb
```{{execute T1}}
Modify the new `postgresql.conf` file to have the new instance use a different port since there is already a database running on the default. The location of the default socket file must also be changed since CentOS tries to put it in a location our training user cannot access. The following `sed` commands can do this for you
```
sed -i "/port = 5432/c\port = 5888" /home/training/mydb/postgresql.conf
```{{execute T1}}
```
sed -i "/unix_socket_directories/c\unix_socket_directories = '/home/training/mydb/'" /home/training/mydb/postgresql.conf
```{{execute T1}}


Since this database isn't managed via a systemd service, use the `pg_ctl` command directly to start it
```
/usr/pgsql-12/bin/pg_ctl -D /home/training/mydb start
```{{execute T1}}

A postgresql database created with initdb by default allows `trust` connections in its `pg_hba.conf` file for all local system users. Also, whichever system user initializes the instance will automatically have a superuser role created with that name, in this case `training`. This can be seen by running the `\du` command via psql in the new instance.
```
psql -d postgres -p 5888 -h localhost -c "\du"
```{{execute T1}}

Now that we have a new instance running, we can run a restore to it.
