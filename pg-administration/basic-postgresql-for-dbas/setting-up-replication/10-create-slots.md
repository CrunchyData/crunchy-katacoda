First let us check to make sure that we have a proper entry in our pg_hba.conf file so that our replica can connect to the primary. It should look like this since we will be running the replica on the same system as the primary:
```
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    replication    replica_user   127.0.0.1/32    md5
```
To check and make sure this is the case, let's log into the database and look. A training role and database has already been created, so you should just be able to type `psql` and log right in. See the first part of this tutorial, `Setting Up PostgreSQL`, for how that was done.

```
psql
```{{execute T1}}
If the output of any of the following commands is hard to read, you can use the `\x` command in psql to turn on/off expanded display mode, which can make output winder than the terminal size easier to read. This is a toggle command that can be enabled/disabled simply by entering it again. Please be sure that if you use this option, and you see `MORE` at the bottom of any query results, you click in the terminal area and then hit Space until all output has been given, or `Q` to cancel, before moving on to the next command.

```
SELECT * FROM pg_hba_file_rules;
```{{execute T1}}

Now, let's create a replication slot for our replica to use. A replication slot is a method in PostgreSQL for the primary server to be aware of where any replicas are within its WAL stream. If a replica disconnects, the primary will retain all WAL files necessary to allow the replica to reconnect and fully resync. Without a replication slot, the primary would normally clean up any WAL files that have had their contents checkpointed. The streaming replica protocal directly uses the primary's WAL files to feed to any replicas, so if they disconnect for a long period of time, they may not be able to resync if the primary has cleaned up its own WAL. With a slot, the primary will not clean up its own WAL stream until all known replicas have confirmed they have received that WAL. This also means it's critically important for disk usage on the primary to monitor your replication status.

https://www.postgresql.org/docs/current/warm-standby.html#STREAMING-REPLICATION-SLOTS
```
SELECT * FROM pg_create_physical_replication_slot('training_replica');
```{{execute T1}}

We can check the status of any existing slots by querying the system catalogs - https://www.postgresql.org/docs/current/view-pg-replication-slots.html
```
SELECT * FROM pg_replication_slots;
```{{execute T1}}
The `active` column shows that this slot does not currently have any replicas attached to it. The `restart_lsn` column being null means that no replica has yet connected to this slot. Once this column has a value, the primary will reserve any WAL files after this lsn value. So it is important to monitor this system catalog for any inactive replication slots.

Let's also create a dedicated replication role instead of using a superuser account.
```
CREATE ROLE replica_user WITH LOGIN REPLICATION PASSWORD 'password';
```{{execute T1}}
We normally recommend setting all role passwords using the `\password` command in psql, but for this scenario we want to ensure a specific value so it is set in this manner.

The `REPLICATION` property gives this role the ability to connect to the special `replication` database and nothing more.

Quit psql for now
```
\q
```{{execute T1}}

