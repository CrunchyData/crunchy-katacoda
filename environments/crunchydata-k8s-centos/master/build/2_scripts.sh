cat <<EOF > /opt/launch-kubeadm.sh
#!/bin/sh
rm $HOME/.kube/config
kubeadm reset -f || true
systemctl start kubelet
mkdir -p /root/.kube
kubeadm init --kubernetes-version $(kubeadm version -o short) --token=96771a.f608976060d16396
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f /opt/weave-kube
EOF

chmod +x /opt/launch-kubeadm.sh

cat <<EOF > /opt/weave-kube
apiVersion: v1
kind: List
items:
  - apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: weave-net
      labels:
        name: weave-net
      namespace: kube-system
  - apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRole
    metadata:
      name: weave-net
      labels:
        name: weave-net
    rules:
      - apiGroups:
          - ''
        resources:
          - pods
          - namespaces
          - nodes
        verbs:
          - get
          - list
          - watch
      - apiGroups:
          - extensions
        resources:
          - networkpolicies
        verbs:
          - get
          - list
          - watch
      - apiGroups:
          - 'networking.k8s.io'
        resources:
          - networkpolicies
        verbs:
          - get
          - list
          - watch
      - apiGroups:
        - ''
        resources:
        - nodes/status
        verbs:
        - patch
        - update
  - apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRoleBinding
    metadata:
      name: weave-net
      labels:
        name: weave-net
    roleRef:
      kind: ClusterRole
      name: weave-net
      apiGroup: rbac.authorization.k8s.io
    subjects:
      - kind: ServiceAccount
        name: weave-net
        namespace: kube-system
  - apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: Role
    metadata:
      name: weave-net
      namespace: kube-system
      labels:
        name: weave-net
    rules:
      - apiGroups:
          - ''
        resources:
          - configmaps
        resourceNames:
          - weave-net
        verbs:
          - get
          - update
      - apiGroups:
          - ''
        resources:
          - configmaps
        verbs:
          - create
  - apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: RoleBinding
    metadata:
      name: weave-net
      namespace: kube-system
      labels:
        name: weave-net
    roleRef:
      kind: Role
      name: weave-net
      apiGroup: rbac.authorization.k8s.io
    subjects:
      - kind: ServiceAccount
        name: weave-net
        namespace: kube-system
  - apiVersion: extensions/v1beta1
    kind: DaemonSet
    metadata:
      name: weave-net
      labels:
        name: weave-net
      namespace: kube-system
    spec:
      # Wait 5 seconds to let pod connect before rolling next pod
      minReadySeconds: 5
      template:
        metadata:
          labels:
            name: weave-net
        spec:
          containers:
            - name: weave
              command:
                - /home/weave/launch.sh
              env:
                - name: HOSTNAME
                  valueFrom:
                    fieldRef:
                      apiVersion: v1
                      fieldPath: spec.nodeName
              image: 'weaveworks/weave-kube:2.5.1'
              imagePullPolicy: Always
              readinessProbe:
                httpGet:
                  host: 127.0.0.1
                  path: /status
                  port: 6784
              resources:
                requests:
                  cpu: 10m
              securityContext:
                privileged: true
              volumeMounts:
                - name: weavedb
                  mountPath: /weavedb
                - name: cni-bin
                  mountPath: /host/opt
                - name: cni-bin2
                  mountPath: /host/home
                - name: cni-conf
                  mountPath: /host/etc
                - name: dbus
                  mountPath: /host/var/lib/dbus
                - name: lib-modules
                  mountPath: /lib/modules
                - name: xtables-lock
                  mountPath: /run/xtables.lock
                  readOnly: false
            - name: weave-npc
              env:
                - name: HOSTNAME
                  valueFrom:
                    fieldRef:
                      apiVersion: v1
                      fieldPath: spec.nodeName
              image: 'weaveworks/weave-npc:2.5.1'
              imagePullPolicy: Always
#npc-args
              resources:
                requests:
                  cpu: 10m
              securityContext:
                privileged: true
              volumeMounts:
                - name: xtables-lock
                  mountPath: /run/xtables.lock
                  readOnly: false
          hostNetwork: true
          hostPID: true
          restartPolicy: Always
          securityContext:
            seLinuxOptions: {}
          serviceAccountName: weave-net
          tolerations:
            - effect: NoSchedule
              operator: Exists
          volumes:
            - name: weavedb
              hostPath:
                path: /var/lib/weave
            - name: cni-bin
              hostPath:
                path: /opt
            - name: cni-bin2
              hostPath:
                path: /home
            - name: cni-conf
              hostPath:
                path: /etc
            - name: dbus
              hostPath:
                path: /var/lib/dbus
            - name: lib-modules
              hostPath:
                path: /lib/modules
            - name: xtables-lock
              hostPath:
                path: /run/xtables.lock
                type: FileOrCreate
      updateStrategy:
        type: RollingUpdate
EOF

cat <<EOF > /usr/local/bin/launch.sh
#!/bin/bash
echo Waiting for Kubernetes to start...
  while [ ! -f /root/.kube/config ]
  do
    sleep 1
  done
echo Kubernetes started
if [ -f /root/.kube/start ]; then
  /root/.kube/start
fi
EOF

chmod +x /usr/local/bin/launch.sh


## Operator work

cat <<EOF > /home/cent/postgres-operator/ansible/inventory
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python"

[all:vars]

crunchy_debug='false'


# Deploy into Kubernetes
# ==================
# Note: Context name can be found using:
#   kubectl config current-context
# ==================
kubernetes_context='kubernetes-admin@kubernetes'

# Create RBAC
# ==================
# Note: you may disable creating RBAC resources if they where already
# provisoned by a cluster admin.
# ==================
create_rbac='true'

# ===================
# PGO Client Container Settings
# The following settings configure the deployment of a PGO Client Container
# ===================
# PGO Client Container Install
pgo_client_container_install='true'

# PGO Apiserver URL - Url to be used to connect to the operator service
#pgo_apiserver_url='https://postgres-operator'

# PGO Client Secret
#pgo_client_cert_secret='pgo.tls'

# ===================
# PGO Settings
# The following settings configure the Crunchy PostgreSQL Operator
# functionality.
# ===================

# The name of the PGO installation
pgo_installation_name='operatorinstall'

# PGO Admin Credentials
pgo_admin_username='admin'
pgo_admin_password='letmein'

# PGO Admin Role & Permissions
pgo_admin_role_name='pgoadmin'
pgo_admin_perms='*'

# Namespace where operator will be deployed
# NOTE: Ansible will create namespaces that don't exist
pgo_operator_namespace='pgo'

# Comma separated list of namespaces Operator will manage
# NOTE: Ansible will create namespaces that don't exist
namespace='opspace,opnamespace'

# Crunchy Container Suite images to use. The tags centos7 and rhel7 are acceptable.
# CentOS7 images can be found in dockerhub: https://hub.docker.com/u/crunchydata
# RHEL7 images are available to Crunchy customers: https://access.crunchydata.com/login/
ccp_image_prefix='crunchydata'
ccp_image_tag='centos7-12.2-4.2.2'

# Name of a Secret containing credentials for container image registries.
# Provide a path to the Secret manifest to be installed in each namespace. (optional)
ccp_image_pull_secret=''
ccp_image_pull_secret_manifest=''

# Crunchy PostgreSQL Operator images to use.  The tags centos7 and rhel7 are acceptable.
pgo_image_prefix='crunchydata'
pgo_image_tag='centos7-4.2.2'

# Name of a Secret containing credentials for container image registries.
# Provide a path to the Secret manifest to be installed in each namespace. (optional)
#pgo_image_pull_secret=''
#pgo_image_pull_secret_manifest=''

# PGO Client Install
pgo_client_install='true'
pgo_client_version='v4.2.2'

# PGO Apiserver TLS Settings
#pgo_tls_no_verify='false'
#pgo_disable_tls='false'
#pgo_apiserver_port=8443
#pgo_tls_ca_store=''
#pgo_add_os_ca_store='false'
#pgo_noauth_routes=''

# PGO Event Settings
#pgo_disable_eventing='false'

# Set to 'true' to assign the cluster-admin role to the PGO service account.  Needed for
# OCP installs to enable dynamic namespace creation (see the PGO docs for more details).
#pgo_cluster_admin='false'

# This will set default enhancements for operator deployed PostgreSQL clusters
backrest='true'
badger='false'
metrics='false'
pod_anti_affinity='preferred'
sync_replication='false'

# pgBadger Defaults
pgbadgerport='10000'

# pgBackRest Defaults
archive_mode='true'
archive_timeout=60
#backrest_port=''

# Log Defaults
log_statement='none'
log_min_duration_statement=60000

# Autofail Settings
disable_auto_failover='false'

# Scheduler Settings
scheduler_timeout=3600

# Service Type for PG Primary & Replica Services
service_type='ClusterIP'

# ===================
# PostgreSQL Settings
# Default parameters for objects created when the database container starts
# such as: default database name and default username
# ===================
db_name='workshop'
db_password_age_days=60
db_password_length=10
db_port=5432
db_replicas=0
db_user='normaluser'

# ==================
# Storage Settings
# ==================
backrest_storage='hostpathstorage'
backup_storage='hostpathstorage'
primary_storage='hostpathstorage'
replica_storage='hostpathstorage'

storage1_name='hostpathstorage'
storage1_access_mode='ReadWriteMany'
storage1_size='1G'
storage1_type='create'

# ==================
# Container Resource Configurations
# ==================
resource1_name='small'
resource1_requests_memory='512Mi'
resource1_requests_cpu=0.1
resource1_limits_memory='512Mi'
resource1_limits_cpu=0.1

# ==================
# Metrics
# ==================
# Optional installation of Grafana and Prometheus optimized
# to work with the Crunchy PostgreSQL Operator

# Note: Ansible will create namespaces that don't exist
metrics_namespace='metrics'
exporterport='9187'

grafana_install='false'
grafana_admin_username='admin'
grafana_admin_password=''
#grafana_storage_access_mode='ReadWriteOnce'
#grafana_storage_class_name='fast'
#grafana_volume_size='1G'
#grafana_supplemental_groups=65534
#grafana_fs_group=26

prometheus_install='false'
#prometheus_storage_access_mode='ReadWriteOnce'
#prometheus_storage_class_name='fast'
#prometheus_volume_size='1G'
#prometheus_supplemental_groups=65534
#prometheus_fs_group=26


# ==================
# Namespace Cleanup
# ==================
# The following settings determine whether or not the PGO and metrics namespaces (defined using
# inventory variables 'pgo_operator_namespace', 'namespace' and 'metrics_namespace') are deleted
# when deprovisioning. Please note that this will also result in the deletion of any non-PGO
# resources deployed in these namespaces, and cannot be undone. By default (and unless otherwise
# specified using the variables below), all namespaces will be preserved when deprovisioning.

#delete_operator_namespace='false'
#delete_watched_namespaces='false'
#delete_metrics_namespace='false'
EOF

cat <<EOF >> ~/.bashrc
export PGOUSER="${HOME?}/.pgo/pgo/pgouser"
export PGO_CA_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_KEY="${HOME?}/.pgo/pgo/client.pem"
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PGO_NAMESPACE=pgouser1
EOF

