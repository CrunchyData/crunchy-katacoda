# Creating PostgreSQL Clusters

Now that we have our port-forward set up in the first tab and have insured our `pgo` client can talk to the operator, let's start making some clusters. 

## Creating your first cluster

Spinning up a database cluster is extremely easy. The following command will spin up a fully functional PostgreSQL instance in the _opspace_ Kuberenetes namespace:

```
pgo create cluster mycluster -n opspace
```

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
```

The response will show you all the Kubernetes metadata about your cluster including service name and storage capacity. 

The Operator also created some secrets to handle username and passwords for the database. To see all the secrets use the following command:

```
kubectl get secrets -n opspace -l pg-cluster=mycluster
``` 

The only secrets we care about are the ones that end in _-secret_. Names for the secrets abide by the following convention:

> clustername-username-secret

So we have a user named _normaluser_, the _postgres_ user (which is the super user), and a user named _primaryuser_ (which is an account used for replication).

To obtain the password for user _normaluser_ we can use the following command:

```
kubectl get secrets/mycluster-normaluser-secret --template={{.data.password}} -n opspace | base64 -d
```

This command gets the password from the secret and then decrypts the password to plain string format.
 
Now we have all the information we need to connect to our cluster

## Connecting to our cluster

By default the created PostgreSQL cluster will not be exposed outside the namespace in the Kubernetes cluster. Therefore, to connect to the cluster we will have to use port-forwarding again 