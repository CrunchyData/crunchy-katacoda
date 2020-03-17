If we need to restore our backups at any time, say due to a dropped table, pgBackRest allows that to be done very efficiently. And with Point-In-Time recovery, we can restore the database to a specific time when we know that it was in a good state.

We'll need to know the time before our table was dropped for this example, so we'll make note of that now using an environment variable to be used later. It is important to represent the time as reckoned by PostgreSQL and to include timezone offsets. This reduces the possibility of unintended timezone conversions and an unexpected recovery result.
```
export RESTORETIME=$(psql -Atc "select current_timestamp")
echo $RESTORETIME
```{{execute T1}}
In practice finding the exact time that the table was dropped is a lot harder than in this scenario. It may not be possible to find the exact time, but some forensic work should be able to get you close

Now let's drop one of our example tables
```
psql -d training -c "DROP TABLE example2"
```{{execute T1}}
We're now in disaster recovery mode, so we'll want to shut down our primary database to minimize any further possible data loss and new data getting added that we would lose anyway when rolling back.
```
sudo systemctl stop postgresql-12
```{{execute T1}}
Note that the last backup is always used by default when running the restore command. If the last backup happened after the desired point in time, the `--set` command can be given to pgBackRest to tell it to use an earlier backup that still exists in the repository. Also by default, the restore location must be empty. But if we're restoring to an existing cluster, the `--delta` option can be used to just overwrite what has changed since the last backup. This can GREATLY speed up recovery times.
```
sudo -Hiu postgres pgbackrest --stanza=main --delta --type=time "--target=$RESTORETIME" --target-action=promote restore
```{{execute T1}}
The `--time` option tells backrest that this PITR is based on a specific point in time and the `--target-action` option tells PostgreSQL what action is desired once that point in time is reached. By default, pgBackRest restores backups in recovery mode, so in this case we want to promote the database out of recovery mode and return to being our primary database.

Start postgres back up again and our table should be back now
```
sudo systemctl start postgresql-12
```{{execute T1}}
```
psql -d training -c "SELECT * FROM example2"

```{{execute T1}}


It's also possible to restore your backups to a different location than the original location. This is useful for disaster recovery situations where you cannot roll back the entire database.
```
sudo -Hiu postgres mkdir /var/lib/pgsql/12/br_restore
sudo -Hiu postgres chmod 700 /var/lib/pgsql/12/br_restore
```{{execute T1}}
```
sudo -Hiu postgres pgbackrest restore --stanza=main --db-path=/var/lib/pgsql/12/br_restore
```{{execute T1}}
If this is done, it is critically important to ***TURN OFF THE ARCHIVE COMMAND***. Otherwise, if your target destination also has write access to the pgBackRest repository, you will have two locations writing there and likely corrupt the entire repository. As stated earlier, the easiest way to disable the archive_command on a linux system is to set it to `/bin/true`.

The Restore section of the pgBackRest user guide has much more thorough explanations of these restore situations - https://pgbackrest.org/user-guide-centos7.html#restore
