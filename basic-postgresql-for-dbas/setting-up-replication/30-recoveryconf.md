Since we're running our replica on the same system as our primary, we'll have to change the port that it runs on. You normally wouldn't need to do this when the replica is running on a separate system. You can either do this manually in the demo terminal, or run the following `sed` command. Change it to run on port `5444`.

```
sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/11/replica/postgresql.conf
```{{execute T1}}
A `recovery.conf` file should have been created for us. Let's take a look at its contents
```
cat /var/lib/pgsql/11/replica/recovery.conf
```{{execute T1}}

 * `standby_mode` - tells postgres whether or not to run in standby mode and treat this system as a replica
 * `primary_conninfo` - the connection string to tell the replica how to connect to its primary
 * `primary_slot_name` - the replication slot to use 

If there are going to be multiple replicas connecting to the primary, and a failover is allowed to happen, we also recommend setting `recovery_target_timeline` as well by adding the following line. This allows any other replicas the ability to reconnect to the new primary once they are pointed to it and pick up where they left off after the failover.
```
recovery_target_timeline='latest'
```

Further options for the recovery.conf file can be found here - https://www.postgresql.org/docs/current/recovery-config.html

Please note that in version 12 of PostgreSQL, the recovery.conf file will be going away and the relevant settings will be moved to the postgresql.conf.

