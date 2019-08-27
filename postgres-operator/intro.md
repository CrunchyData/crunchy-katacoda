# PostgreSQL Cluster Operation with PostgreSQL Operator for Kubernetes

This scenario is going to give you an introduction to PostgreSQL cluster creation and operation using the PostgreSQL Operator for Kubernetes. 

With the PostgreSQL Operator for Kubernetes installed in your Kubernetes environment, application developers have the ability easily provision and manage PostgreSQL clusters using a set of simple commands. The goal of this class is to introduce you to the PostgreSQL Operator for Kubernetes capability and get your started with some basic PostgreSQL cluster operations. 

This scenario will work through the commands associated with:

* creating a single instance PostgreSQL cluster 

* adding a PostgreSQL replica to your PostgreSQL cluster 

* viewing the PostgreSQL logs

* create a PostgreSQL backup job using pgbackrest 

* remove a PostgreSQL replica using the following:

* delete the PostgreSQL cluster and its associated persistent volume claims

The PostgreSQL Operator by Crunchy Data extends Kubernetes to give users the ability to easily  create, configure and manage PostgreSQL clusters at scale.  When combined with the Crunchy Data's PostgreSQL Containers, the PostgreSQL Operator provides an open source software solution for PostgreSQL scaling, high-availability, disaster recovery, monitoring, and more.  All of this capability comes with the repeatability and automation that comes from Operators on Kubernetes.

We have deployed the PostgreSQL Operator in a Google Kubernetes Engine (GKE) environment for you. 




