## Setup Before Running the Examples

Many of the `pgo` client commands require you to specify a namespace via the
`-n` or `--namespace` flag. 

If you install the PostgreSQL Operator using the quickstart
guide, you will have two namespaces installed: `pgouser1` and `pgouser2`. We
can choose to always use one of these namespaces by setting the `PGO_NAMESPACE`
environmental variable, which is detailed in the global pgo Client
reference. 

For convenience, we will use the `pgouser1` namespace in the examples below.
For even more convenience, we recommend setting `pgouser1` to be the value of
the `PGO_NAMESPACE` variable. 

In the shell that you will be executing the `pgo`commands in, run the following command:

```shell
export PGO_NAMESPACE=pgouser1
```

If you do not wish to set this environmental variable, or are in an environment
where you are unable to use environmental variables, you will have to use the
`--namespace` (or `-n`) flag for most commands, e.g.

`pgo version -n pgouser1`

### JSON Output

The default for the `pgo` client commands is to output their results in a
readable format. However, there are times where it may be helpful to you to have
the format output in a machine parseable format like JSON.

Several commands support the `-o`/`--output` flags that delivers the results of
the command in the specified output. Presently, the only output that is
supported is `json`.

As an example of using this feature, if you wanted to get the results of the
`pgo test` command in JSON, you could run the following:

```shell
pgo test hacluster -o json

### Checking Connectivity to the PostgreSQL Operator

A common administrative task when working with the PostgreSQL Operator is to check connectivity
to the PostgreSQL Operator. This can be accomplish with the ```pgo version``` command:

```shell
pgo version
```

which, if working, will yield results similar to:

```
pgo client version 4.3.0
pgo-apiserver version 4.3.0
```

### Inspecting the PostgreSQL Operator Configuration

The ```pgo show config``` command allows you to view the current configuration that 
the PostgreSQL Operator is using. This can be helpful for troubleshooting issues such 
as which PostgreSQL images are being deployed by default, which storage classes are 
being used, etc.

You can run the ```pgo show config``` command by running:

```shell
pgo show config
```

which yields output similar to:

BasicAuth: ""
Cluster:
  CCPImagePrefix: crunchydata
  CCPImageTag: centos7-12.2-4.3.0
  PrimaryNodeLabel: ""
  ReplicaNodeLabel: ""
  Policies: ""
  Metrics: false
  Badger: false
  Port: "5432"
  PGBadgerPort: "10000"
  ExporterPort: "9187"
  User: testuser
  Database: userdb
  PasswordAgeDays: "60"
  PasswordLength: "8"
  Strategy: "1"
  Replicas: "0"
  ServiceType: ClusterIP
  BackrestPort: 2022
  Backrest: true
  BackrestS3Bucket: ""
  BackrestS3Endpoint: ""
  BackrestS3Region: ""
  DisableAutofail: false
  PgmonitorPassword: ""
  EnableCrunchyadm: false
  DisableReplicaStartFailReinit: false
  PodAntiAffinity: preferred
  SyncReplication: false
Pgo:
  PreferredFailoverNode: ""
  Audit: false
  PGOImagePrefix: crunchydata
  PGOImageTag: centos7-4.3.0
ContainerResources:
  large:
    RequestsMemory: 2Gi
    RequestsCPU: "2.0"
    LimitsMemory: 2Gi
    LimitsCPU: "4.0"
  small:
    RequestsMemory: 256Mi
    RequestsCPU: "0.1"
    LimitsMemory: 256Mi
    LimitsCPU: "0.1"
PrimaryStorage: nfsstorage
BackupStorage: nfsstorage
ReplicaStorage: nfsstorage
BackrestStorage: nfsstorage
Storage:
  nfsstorage:
    AccessMode: ReadWriteMany
    Size: 1G
    StorageType: create
    StorageClass: ""
    Fsgroup: ""
    SupplementalGroups: "65534"
    MatchLabels: ""
DefaultContainerResources: ""
DefaultLoadResources: ""
DefaultRmdataResources: ""
DefaultBackupResources: ""
DefaultBadgerResources: ""
DefaultPgbouncerResources: ""

### Viewing PostgreSQL Operator Key Metrics

The ```pgo status``` command provides a generalized statistical view of 
the overall resource consumption of the PostgreSQL Operator. These stats include:

- The total number of PostgreSQL instances
- The total number of Persistent Volume Claims (PVC) that are allocated, along with the total amount of disk the claims specify
- The types of container images that are deployed, along with how many are deployed
- The nodes that are used by the PostgreSQL Operator

and more

You can use the ```pgo status``` command by running:

```shell
pgo status
```

which yields output similar to:


Operator Start:          2019-12-26 17:53:45 +0000 UTC
Databases:               8
Claims:                  8
Total Volume Size:       8Gi       

Database Images:
                         4	crunchydata/crunchy-postgres-ha:centos7-12.2-4.3.0
                         4	crunchydata/pgo-backrest-repo:centos7-4.3.0
                         8	crunchydata/pgo-backrest:centos7-4.3.0

Databases Not Ready:

Nodes:
	master                        
		Status:Ready                         
		Labels:
			beta.kubernetes.io/arch=amd64
			beta.kubernetes.io/os=linux
			kubernetes.io/arch=amd64
			kubernetes.io/hostname=master
			kubernetes.io/os=linux
			node-role.kubernetes.io/master=
	node01                        
		Status:Ready                         
		Labels:
			beta.kubernetes.io/arch=amd64
			beta.kubernetes.io/os=linux
			kubernetes.io/arch=amd64
			kubernetes.io/hostname=node01
			kubernetes.io/os=linux

Labels (count > 1): [count] [label]
	[8]	[vendor=crunchydata]
	[4]	[pgo-backrest-repo=true]
	[4]	[pgouser=pgoadmin]
	[4]	[pgo-pg-database=true]
	[4]	[crunchy_collect=false]
	[4]	[pg-pod-anti-affinity=]
	[4]	[pgo-version=4.3.0]
	[4]	[archive-timeout=60]
	[2]	[pg-cluster=hacluster]


### Viewing PostgreSQL Operator Managed Namespaces

The PostgreSQL Operator has the ability to manage PostgreSQL clusters across
Kubernetes Namespaces. During the course of PostgreSQL Operator operations, 
it can be helpful to know which namespaces the PostgreSQL Operator can use 
for deploying PostgreSQL clusters.

You can view which namespaces the PostgreSQL Operator can utilize by using
the ```pgo show namespace``` command. To list out the namespaces that the PostgreSQL 
Operator has access to, you can run the following command:

```shell
pgo show namespace --all
```

which yields output similar to:

pgo username: pgoadmin
namespace                useraccess          installaccess       
default                  accessible          no access           
kube-node-lease          accessible          no access           
kube-public              accessible          no access           
kube-system              accessible          no access           
pgo                      accessible          no access           
pgouser1                 accessible          accessible          
pgouser2                 accessible          accessible          
somethingelse            no access           no access   


Based on your deployment, your Kubernetes administrator may restrict
access to the multi-namespace feature of the PostgreSQL Operator. In this case,
you do not need to worry about managing your namespaces and as such do not need
to use this command, but we recommend setting the `PGO_NAMESPACE` variable as
described in the PostgreSQL Operator documentation. 
