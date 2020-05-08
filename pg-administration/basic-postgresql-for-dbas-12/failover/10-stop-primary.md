This scenario has had the same replica setup already done that was shown in the `Replication` scenario of this training program. If you'd like more information on how replicas are set up, please refer to that previous scenario . The primary is running on the default port of 5432 and the replica is running on port 5444. You can see the running clusters by observing some ps output.

```
ps aux | grep postgres
```{{execute T1}}

This will be a planned failover, but the process for an unplanned failover will be very similar. The key part of the unplanned scenario is ensuring that your primary that appears to be down is really down and will not be able come up unexpectedly again in the future and cause a split-brain scenario where database writes are going to more than one location. How you ensure this is very dependent on your environment, but somehow ensuring all of your applications are pointed to the new primary is key.

As a first step, let's shut down the primary
```
sudo systemctl stop postgresql-12
```{{execute T1}}
After a few moments, checking the replica's logs should show that it is unable to connect to its primary anymore. If you're doing a planned failover, it is highly recommended to wait until you start seeing these messages on the replica. This ensures it has fully caught up to the last transaction that was committed to the primary.
```
sudo bash -c "tail /var/lib/pgsql/12/replica/log/*"
```{{execute T1}}
The message to be looking for should be similar to
```
FATAL:  could not connect to the primary server: could not connect to server: Connection refused
```
