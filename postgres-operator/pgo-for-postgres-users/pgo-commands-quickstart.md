# PostgreSQL Operator Commands Quickstart for PostgreSQL Users

In this example, we will assume that the PostgreSQL Operator has been installed and configured in your Kubernetes environment, and focus on working through a few of the common ```pgo``` commands that would be used by a typical PostgreSQL user in a Kubernetes environment.  work through the creation of a PostgreSQL cluster using the PostgreSQL Operator, as well as perform a few common PostgreSQL cluster operations. 

Throughout this example, the pgo commands are specifying the pgouser1 namespace as the target of the PostgreSQL Operator. 

Replace this value with your own namespace value. You can specify a default namespace to be used by setting the PGO_NAMESPACE environment variable on the pgo client environment.

To begin, we will use the PostgreSQL Operator to create a single instance PostgreSQL cluster using the following ```pgo``` command:

```pgo create cluster mycluster -n pgouser1```

This command creates a PostgreSQL cluster in the pgouser1 namespace that has a single PostgreSQL primary container.

You can see the PostgreSQL cluster running in your environment using the following ```pgo``` command: 

```pgo show cluster mycluster -n pgouser1```

You can test the PostgreSQL cluster by using the following ```pgo``` command: 

```pgo test mycluster -n pgouser1```

With the PostgreSQL instance up and running, you can now add a PostgreSQL replica instance to your PostgreSQL cluster. As a reminder, PostgreSQL has a single primary / multiple read replica architecture. 

To add a PostgreSQL replica to your PostgreSQL cluster, use the following ```pgo``` command:

```pgo scale mycluster -n pgouser1```

By default the PostgreSQL Operator deploys pgbackrest for a PostgreSQL cluster to hold database backup data.  pgbackrest is an open source, high performance, backup and restore utility for PostgreSQL. 

To create a pgbackrest backup job, use the following ```pgo``` command:

```pgo backup mycluster -n pgouser1```

You can show the current backups on a PostgreSQL cluster with the following ```pgo``` command:

```pgo show backup mycluster -n pgouser1```

To the extent you determined that you no longer need your read replica PostgreSQL instance, you can remove the PostgreSQL replica instance using the following ```pgo``` command:

```pgo scaledown mycluster --query -n pgouser1```
```pgo scaledown mycluster --target=sometarget -n pgouser1```

To delete the full PostgreSQL cluster and the associated persistent volume claims, you can use the following ```pgo``` command:

```pgo delete cluster mycluster --delete-data -n pgouser1```

With that sequence of simple commands, you have spun up a PostgreSQL cluster, scaled it up with a read replica, created a backup, scaled the cluster down and ultimately deleted your cluster. 
