## Using the Crunchy PostgreSQL Operator for Kubernetes (_The Operator_) to make a DB Cluster

The Operator has already been installed into the running Kubernetes cluster, so our first step will be to connect to it. The simplest method to connect to The Operator is to use Kubernetes port-forwarding. We will just connect port 8443 on our client machine directly to the service for The Operator, which will then forward our requests and responses on to The Operator pod. The Operator has been installed in the Kubernetes PGO namespace. 

## Port-forwarding 

By default, in a Kubernetes cluster, The Operators is not accessible outside of the namespace. The easiest way for us to connect is by using port-forwarding. The only information you need to set the up port-forward is the namespace where The Operator was installed, in this case it was "pgo". Now we just do:

```
kubectl port-forward svc/postgres-operator 8443:8443 -n pgo
```

This terminal tab will now be blocked with the port-forward. 

## Connecting to The Operator

Since our first tab is block go ahead and click on the tab titled 'Operator Commands Here'. We will use this terminal tab to carry out The Operator Commands. To start with, let's just make sure the `pgo` client is working and then go back and show you the steps we had to do to make sure it worked. Let's get the version from both the client and the server

```
pgo version
``` 

You should see 4.2.2 for both the client and server. The fact this command gave us information on the server means our `pgo` client is successfully talking to The Operator in our Kubernetes cluster.

## Prerequisites

In order for this command to work successfully there were several steps we automated behind the scenes for you. Let's go through them so if you do this at home you have some familiarity with what's required.

First we will look at the _.pgo_ directory. This directory is created in the home directory of the user that installed The Operator. Since your account installed The Operator, you can just: 

```
cd .pgo/pgo/
```

and then 

```
ls 
```

The basic contents of this directory contain the certificates to talk over TLS to The Operator (client.crt and client.pem) and the pgouser file which is the username and password for the admin. These files will be referenced in the environment variables.

The `pgo` command line tool references environment variables for it's connection information. You can pass most of this same information in using flags to the command line but that is tedious and error prone.

Let's look at the environment variables set in the initialization of the scenario (under the hoods so you didn't have to bother with it):

```
cat  ~/.bashrc |grep export
```
   
Your output should be this:   

```
export PGOUSER="/root/.pgo/pgo/pgouser"
export PGO_CA_CERT="/root/.pgo/pgo/client.crt"
export PGO_CLIENT_CERT="/root/.pgo/pgo/client.crt"
export PGO_CLIENT_KEY="/root/.pgo/pgo/client.pem"
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PGO_CMD='kubectl'
export PGO_OPERATOR_NAMESPACE='pgo'
```

You can see that we pointed to those files in the .pgo directory. Since we used port-forwarding we set the address for The Operator API server to be localhost. We are using a community distribution of Kuberenetes, rather than the OpenShift distribution, so our kube cli is `kubectl`. Finally, The Operator was installed in the _pgo_ namespace in the kubernetes cluster. 

## Summary
We covered the two essentials configuration changes you need to make to you machine to get the `pgo` client to connect to The Operator. Showing you this was solely done so you could repeat this at home on your own machines. Here it was automatically configured for you. And finally, we made a port-forward between our terminal and the Kubernetes cluster so our `pgo` client is all set to go. Let's go make some PostgreSQL clusters! 

In this section talk about how we could connect so easily once we set up the port-forward
The .bashrc and the .pgo directory

```

```