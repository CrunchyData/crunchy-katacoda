First let us check to make sure that we have a proper entry in our pg_hba.conf file so that our replica can connect to the primary. It should look like this since we will be running the replica on the same system as the primary:
```
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    replication    replica_user   127.0.0.1/32    md5
```
To check and make sure this is the case, let's log into the database and look. A root role and database has already been created, so you should just be able to type `psql` and log right in. See the first part of this tutorial, `Setting Up PostgreSQL`, for how that was done.

```
psql
```{{execute T1}}
If the output of any of the following commands is hard to read, you can use the `\x` command in psql to turn on/off expanded display mode, which can make output winder than the terminal size easier to read. This is a toggle command that can be enabled/disabled simply by entering it again. Please be sure that if you use this option, and you see `MORE` at the bottom of any query results, you hit Space until all output has been given, or `Q` to cancel, before moving on to the next command.

```
SELECT * FROM pg_hba_file_rules;
```{{execute T1}}

Now, let's create a replication slot for our replica to use


```
SELECT * FROM pg_create_physical_replication_slot('training_replica');
```{{execute T1}}

We can the status of any existing slots by querying the system catalogs
```
SELECT * FROM pg_replication_slots;
```{{execute T1}}
Let's also create a dedicated replication role instead of using a superuser account.
```
CREATE ROLE replica_user WITH LOGIN REPLICATION PASSWORD 'password';
```{{execute T1}}
We normally recommend setting all role passwords using the `\password` command in psql.

The `REPLICATION` property gives this role the ability to connect to the special replication database and nothing more.

Quit psql for now
```
\q
```{{execute T1}}

