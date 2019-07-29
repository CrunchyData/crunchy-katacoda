There are two commands used to perform data dumps in PostgreSQL. The pg_hba.conf file has been configured in this environment to allow all the commands that are run to connect without requiring a password. For your own environment, you'll have to use whichever credentials allow you to connect and read the necessary information. 

The first, `pg_dumpall`, is a very simplistic and only does plaintext dumps of the entire instance. 

https://www.postgresql.org/docs/current/app-pg-dumpall.html

This is often not the most useful form of a dump since both the dump and the restore of the database are all or nothing. What it is useful for is dumping out data that is only cluster-wide, such as roles and tablespaces. In fact, this is the only way to dump out such data. The location of our dump output will be the home directory of the non-root user, `training`.

```
pg_dumpall -g -f /home/training/globals.sql
```{{execute T1}}
The `-g` option tells pg_dumpall to dump out only the cluster-wide data. In the case of this scenario, this will just be the roles. Run the following command the see the contents of this dump

```
cat /home/training/globals.sql
```{{execute T1}}

Often a superuser role is required for this tool, especially when extracting global data.

We'll be restoring this in a secondary database in a later step. Next let's look at the command that is recommended to be used when dumping out actual databases.
