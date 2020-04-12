# Introduction to Using the Crunchy PostgreSQL Operator

Welcome to the course on doing some basic operations with the Crunchy PostgreSQL Operator for Kubernetes. As the documentation says:  

>The Crunchy PostgreSQL Operator automates and simplifies deploying and managing open source PostgreSQL clusters on Kubernetes and other Kubernetes-enabled Platforms by providing the essential features you need to keep your PostgreSQL clusters up and running, including:
>
>**PostgreSQL Cluster Provisioning**
>
>Create, Scale, & Delete PostgreSQL clusters with ease, while fully customizing your Pods and PostgreSQL configuration!
>
>**High-Availability**
>
>  Safe, automated failover backed by a distributed consensus based high-availability solution. 
>
>**Disaster Recovery**
>
>Backups and restores leverage the open source pgBackRest utility and includes support for full, incremental, and differential backups as well as efficient delta restores. 
>
>**Monitoring**
>
>Track the health of your PostgreSQL clusters using the open source pgMonitor library.
>
>**PostgreSQL User Management**
>
>Quickly add and remove users from your PostgreSQL clusters with powerful commands. Manage password expiration policies or use your preferred PostgreSQL authentication scheme.
>
>**Upgrade Management**
>
>Safely apply PostgreSQL updates with minimal availability impact to your PostgreSQL clusters.
>
>**Advanced Replication Support**
>
>Choose between asynchronous replication and synchronous replication for workloads that are sensitive to losing transactions.
>
>**Clone**
>
>Create new clusters from your existing clusters with a simple pgo clone command.
>
>**Connection Pooling**
Provision and use pgBouncer for connection pooling
>
>**Scheduled Backups and optional storage to S3**
>
> Choose the type of backup (full, incremental, differential) and how frequently you want it to occur on each PostgreSQL cluster.Store your backups in Amazon S3 or any object storage system that supports the S3 protocol.

 
We already have a Kubernetes cluster running (one master and one node) and have installed the PostgreSQL Operator. We are just going to focus on some very basic operations: 

1. Connect to the PostgreSQL Operator
1. Spin up a cluster
1. Look around a bit in Kubernetes
1. Add some data to the database
1. Delete our cluster

## Assumptions

To do this class we assume you understand, and preferable played with:

1. Basic Kubernetes and `kubectl` commands (if not [these](https://kubernetes.io/docs/concepts/) will be [helpful](https://kubernetes.io/docs/reference/kubectl/cheatsheet/))
1. [PostgreSQL](https://www.postgresql.org/docs/12/tutorial.html) and `psql` [commands](https://learn.crunchydata.com/postgresql-devel/courses/basics/)
1. A command line