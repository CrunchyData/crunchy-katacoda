# Deleting your PostgreSQL Clusters Using The Operator

We created a couple of clusters in this class and perhaps you would like to clean them up from your environment.  In this final section we will cover how to delete your PostgreSQL clusters using the Operator.

## Completely deleting a cluster and all its data.  

First let's just query which clusters The Operator is mananging in our namespace.

```
pgo show cluster --all -n opspace
```

We can see that we have two clusters: _bigcluster_ and _mycluster_. Let's go ahead and completely delete everything associated with the replicated cluster, _bigcluster_.

```
pgo delete cluster bigcluster -n opspace
```

When given the warning about this deleting all your data reply _yes_.

And that's it - The Operator will go through and clean up all the Kubernetes objects associated with this cluster. **WARNING**, like the prompt said, these changes are not reversible, there is no undo.

Again, one of the benefits of The Operator is that it makes a lot of typical administration routines simple and automated. Rather than having to go through and remember which Kubernetes pieces were created for the primary and the replicas, you just used this one command and The Operator "does the right thing". 

## Deleting a cluster but keeping the data. 

You might be wondering why delete the cluster but keep the data in the PVC. Well perhaps you did not like the configuration of your PostgreSQL server for your cluster but you want to keep the data you already entered. If you delete a cluster and create a new one with the same name, The Operator will use the data stored on the PVC as its data and will not _initdb_ (create a blank database) as it usually does.

And again this command is very simple with just a new flag added to the command above:

```
pgo delete cluster mycluster --keep-data -n opspace
```  

Once again, reply _yes_ to the prompt (which you should notice has slightly different wording this time).

Now if you don't believe that the data is still there you can first check to see if the pods have been deleted for the cluster.

```
kubectl get pods -n opspace
```

This command should say "No resources found in the opspace namespace". If there are any pods they are probably scheduled to be deleted. You can wait a bit and then try the command above one more time. 

Now let's see if the PVC is still there:

```
kubectl get pods -n opspace
```

Since you deleted all the data for _bigcluster_, you should only the one pvc named _mycluster_.

## Summary

And with that you have cleaned up all the pieces of your clusters that you wanted to. Using The Operator you were able to reduce complicated and repetitive tasks to simple commands.  
