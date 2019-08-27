# PostgreSQL Cluster Creation

In this example, we will work throug the creation of a PostgreSQL cluster using the PostgreSQL Operator, as well as perform afew common PostgreSQL cluster operations. 

The user is specifying the pgouser1 namespace as the target of the PostgreSQL Operator. 

Replace this value with your own namespace value. You can specify a default namespace to be used by setting the PGO_NAMESPACE environment variable on the pgo client environment.

To begin, we will use the PostgreSQL Operator to create a single instance PostgreSQL cluster using the following command:

```pgo create cluster mycluster -n pgouser1```

This command creates a Postgres cluster in the pgouser1 namespace that has a single Postgres primary container.

You can see the Postgres cluster using the following:

pgo show cluster mycluster -n pgouser1

You can test the Postgres cluster by entering:

pgo test mycluster -n pgouser1

You can optionally add a Postgres replica to your Postgres cluster as follows:

pgo scale mycluster -n pgouser1

You can create a Postgres cluster initially with a Postgres replica as follows:

pgo create cluster mycluster --replica-count=1 -n pgouser1

To view the Postgres logs, you can enter commands such as:

pgo ls mycluster -n pgouser1 /pgdata/mycluster/pg_log
pgo cat mycluster -n pgouser1 /pgdata/mycluster/pg_log/postgresql-Mon.log | tail -3

Backups

By default the Operator deploys pgbackrest for a Postgres cluster to hold database backup data.

You can create a pgbackrest backup job as follows:

pgo backup mycluster -n pgouser1

You can perform a pgbasebackup job as follows:

pgo backup mycluster --backup-type=pgbasebackup -n pgouser1

You can optionally pass pgbackrest command options into the backup command as follows:

pgo backup mycluster --backup-type=pgbackrest --backup-opts="--type=diff" -n pgouser1

See pgbackrest.org for command flag descriptions.

You can create a Postgres cluster that does not include pgbackrest if you specify the following:

pgo create cluster mycluster --pgbackrest=false -n pgouser1

You can show the current backups on a cluster with the following:

pgo show backup mycluster -n pgouser1

Scaledown a Cluster

You can remove a Postgres replica using the following:

pgo scaledown mycluster --query -n pgouser1
pgo scaledown mycluster --target=sometarget -n pgouser1

Delete a Cluster

You can remove a Postgres cluster by entering:

pgo delete cluster mycluster -n pgouser1

Delete a Cluster and Its Persistent Volume Claims

You can remove the persistent volumes when removing a Postgres cluster by specifying the following command flag:

pgo delete cluster mycluster --delete-data -n pgouser1

View Disk Utilization

You can see a comparison of Postgres data size versus the Persistent volume claim size by entering the following:

pgo df mycluster -n pgouser1

