## Using the Crunchy PostgreSQL Operator for Kubernetes (_The Operator_) to make a DB Cluster

The Operator has already been installed into the running Kubernetes cluster, so our first step will be to connect to it. The simplest method to connect to The Operator is to use Kubernetes port-forwarding. We will just connect port 8443 on our client machine directly to the service for The Operator, which will then forward our requests and responses on to The Operator pod. The Operator has been installed in the Kubernetes PGO namespace. 

## Port-forwarding 

By default, in a Kubernetes cluster, The Operators is not accesible outside of the namespace. The easiest way for us to connect is by using port-forwarding. The only information you need to set the up port-forward is the namespace where The Operator was installed, in this case it was "pgo". Now we just do

```
kubectl port-forward svc/postgres-operator 8443:8443 -n pgo
```

Now in the 
In this section talk about how we could connect so easily once we set up the port-forward
The .bashrc and the .pgo directory

```
 "terminals": [
      {"name": "Port-Forward Here", "target": "host01"},
      {"name": "Operator Commands Here", "target": "host01"},
      {"name": "PSQL Commands Here", "target": "host01"}
    ],
```