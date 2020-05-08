# Creating PostgreSQL Clusters

Now that we have our port-forward set up in the first tab and have insured our `pgo` client can talk to the operator, let's start making some clusters. 

## Creating your first cluster

Spinning up a database cluster is extremely easy. The following command will spin up a fully functional PostgreSQL instance in the _opspace_ Kuberenetes namespace:

```
pgo create cluster mycluster -n opspace
```{{execute}}

The command will return a workflow id to track the progress of the cluster creation. The name of our database cluster will be _mycluster_.

To track the cluster progress you can simply do:

```
pgo show workflow <your workflow id> -n <your namespace>
```

While writing the tutorial this is what I obtained as output:

```
[root@master ~]# pgo create cluster mycluster -n opspace
created Pgcluster mycluster
workflow id 97e5f1fb-dc14-4e70-a695-4b559bfa79fb
[root@master ~]# pgo show workflow 97e5f1fb-dc14-4e70-a695-4b559bfa79fb -n opspace
parameter           value
---------           -----
workflowid          97e5f1fb-dc14-4e70-a695-4b559bfa79fb
pg-cluster          mycluster
task submitted      2020-04-20T21:47:49Z
```

and then I wait a while and I get

```
[root@master ~]# pgo show workflow 97e5f1fb-dc14-4e70-a695-4b559bfa79fb -n opspace
parameter           value
---------           -----
workflowid          97e5f1fb-dc14-4e70-a695-4b559bfa79fb
pg-cluster          mycluster
task completed      2020-04-20T21:48:35Z
task submitted      2020-04-20T21:47:49Z
```

When the task submitted line appears we know the cluster has been created. And that's how easy it is to create a PostgreSQL cluster.

## Seeing information on our cluster

If you want to see the configuration on the cluster all you have to do is this command:

```
pgo show cluster mycluster -n opspace
```{{execute}}

The response will show you all the Kubernetes metadata about your cluster including service name and storage capacity. 

The Operator also created some secrets to handle usernames and passwords for the database. To see all the secrets use the following command:

```
kubectl get secrets -n opspace -l pg-cluster=mycluster
``` {{execute}}

The only secrets we care about are the ones that end in _-secret_. Names for the secrets abide by the following convention:


> clustername-username-secret

So we have a user named _normaluser_, the _postgres_ user (which is the super user), and a user named _primaryuser_ (which is an account used for replication).

To obtain the password for user _normaluser_ we can use the following command:

```
kubectl get secrets/mycluster-normaluser-secret --template={{.data.password}} -n opspace | base64 -d
```{{execute}}

This command gets the password from the secret and then decrypts the password to plain string format.
 
Now we have all the information we need to connect to our cluster

## Connecting to our cluster

By default the created PostgreSQL cluster will not be exposed outside the namespace in the Kubernetes cluster. Therefore, to connect to the cluster we will have to use port-forwarding again. In this terminal window we will set up the port-forward and then use the 'PSQL Commands Here' terminal to run our other commands. 

First the port-forward in the current terminal:

```
kubectl port-forward svc/mycluster 5432:5432 -n opspace
```{{execute}}

Note, if you have kubectl on your local machine you could use the same command to port-forward from your local machine to your PostgreSQL instance running in your Kubernetes cluster. From there you can connect any of the desktop tools you usually use to work with your database, such as the psql command line, PgAdmin, [DBeaver](https://dbeaver.io/), [DataGrip](https://www.jetbrains.com/datagrip/), or your IDE of choice by connecting to localhost on your machine.


Now in the 'PSQL Commands Here' terminal let's get the user _normaluser_'s password.

```
kubectl get secrets/mycluster-normaluser-secret --template={{.data.password}} -n opspace | base64 -d
```{{execute}}

And now we can use the `psql` command line client to connect to our database. 

```
psql -h localhost -U normaluser workshop
```{{execute}}

When prompted for a password use the output from the kubectl command two steps back. After doing that you should be greeted with the normal `psql` prompt. You can go ahead and enter any PostgreSQL commands you want. To disconnect from the database you can type **ctrl+d**, `\q` or simply 'quit' ('exit' would work too).

Next we will spin up a more exciting PostgreSQL cluster. Let's go back to the 'Operator Command Here' tab and type **ctrl+c** to break the port forward. Make sure you get the command prompt that looks like:

```
[root@master pgo]#
```

Stay in this window for the next section.  
 
 ## Creating a replicated cluster
 
 One of the great parts about using The Operator to create your PostgreSQL instances is it's ability to create an advanced architecture with simple commands. In this case we are going to create a read replicated cluster with one primary and two replicas, all with one command. Again, prepare to be shocked at how easy this can be:
 
 ```
pgo create cluster bigcluster --replica-count 2 -n opspace
```{{execute}}

You can use the normal `pgo show workflow <workflowid>` to track cluster creation. Once it is finished go ahead look at the Kubernetes metadata for the cluster:

```
pgo show cluster bigcluster -n opspace
```{{execute}}

Your output should look like this (except the random letter and numbers will be different).

```
cluster : bigcluster (crunchy-postgres-ha:centos7-12.2-4.2.2)
        pod : bigcluster-7b6698d66b-l7d5s (Running) on node01 (1/1) (primary)
        pvc : bigcluster
        pod : bigcluster-xqtr-6f4f6d8c9-nvhgb (Running) on node01 (1/1) (replica)
        pvc : bigcluster-xqtr
        pod : bigcluster-yokc-7885f665f6-mnsds (Running) on node01 (1/1) (replica)
        pvc : bigcluster-yokc
        resources : CPU Limit= Memory Limit=, CPU Request= Memory Request=
        storage : Primary=1G Replica=1G
        deployment : bigcluster
        deployment : bigcluster-backrest-shared-repo
        deployment : bigcluster-xqtr
        deployment : bigcluster-yokc
        service : bigcluster - ClusterIP (10.101.210.151)
        service : bigcluster-replica - ClusterIP (10.96.36.161)
        pgreplica : bigcluster-xqtr
        pgreplica : bigcluster-yokc
        labels : crunchy-pgha-scope=bigcluster name=bigcluster pg-cluster=bigcluster pgo-version=4.2.2 workflowid=d188e2da-3df3-4c4d-b2ab-39a7cb06431a autofail=true crunchy-pgbadger=false pg-pod-anti-affinity= pgo-backrest=true crunchy_collect=false current-primary=bigcluster archive-timeout=60 deployment-name=bigcluster pgouser=admin
```

As you can see there are a lot more pieces to your PostgreSQL cluster now. If we start with the pods you can see there are now 3 of them: the primary, bigcluster-7b6698d66b-l7d5s, and the two replicas, bigcluster-xqtr-6f4f6d8c9-nvhgb and bigcluster-yokc-7885f665f6-mnsds. The replicas will always have the cluster name followed by four alpha characters. The persistent volume claims for each database cluster also share the beginning of their name with the pod.  

You can also see that we now have 2 services, one for the primary and one for the replicas. This is really nice for spreading out application load - the replicas can handle all your read queries while writes go to the primary. 

This cluster will also automatically promote one of the replicas to be the primary if the original primary goes down. With one command you have just made your database highly available.   

## Summary 

In this section we saw just how easy it is to spin up a PostgreSQL cluster in Kubernetes using the Crunchy PostgreSQL Operator. Then we looked at the different parts The Operator created, especially the usernames and passwords for the database. We learned how to connect to our PostgreSQL instance and interact with the database. Finally, we added one flag to the cluster creation command and spun up a replicated PostgreSQL cluster. 

In the final section we will look at how to clean up and remove the clusters we created.
