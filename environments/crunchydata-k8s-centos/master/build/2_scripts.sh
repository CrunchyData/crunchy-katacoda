sudo docker pull storageos/node:1.5.3

cat <<EOFPARENT > /opt/create-pv.sh
kubectl create -f https://github.com/storageos/cluster-operator/releases/download/1.5.3/storageos-operator.yaml

cat << EOF1 > storageos-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: "storageos-api"
  namespace: "storageos-operator"
  labels:
    app: "storageos"
type: "kubernetes.io/storageos"
data:
  # echo -n '<secret>' | base64
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
EOF1

kubectl create -f storageos-secret.yaml

cat << EOF2 > storageos-cluster.yaml
apiVersion: "storageos.com/v1"
kind: StorageOSCluster
metadata:
  name: "example-storageos"
  namespace: "storageos-operator"
spec:
  secretRefName: "storageos-api" # Reference the Secret created in the previous step
  secretRefNamespace: "storageos-operator"  # Namespace of the Secret
  k8sDistro: "kubernetes"
  images:
    nodeContainer: "storageos/node:1.5.3" # StorageOS version
  csi:
    enable: true
    deploymentStrategy: deployment
  resources:
    requests:
    memory: "512Mi"
  disableTelemetry: true
EOF2

kubectl create -f storageos-cluster.yaml

EOFPARENT

chmod +x /opt/create-pv.sh

cat <<EOF > /opt/launch-kubeadm.sh
#!/bin/sh
rm \$HOME/.kube/config
kubeadm reset -f || true
systemctl start kubelet
mkdir -p /root/.kube
kubeadm init --kubernetes-version \$(kubeadm version -o short) --token=96771a.f608976060d16396
mkdir -p \$HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config
sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config
kubectl apply -f /opt/weave-kube

# while true; do
#    NUM_READY=\$(kubectl get nodes 2> /dev/null | grep -v NAME | awk '{print \$2}' | grep -e ^Ready | wc -l)
#    if [ "\${NUM_READY}" == "2" ]; then
#        echo "\${NUM_READY} Kubernetes nodes"
#        break
#    else
#        echo "Waiting for 2 Kubernetes nodes: \${NUM_READY}"
#        kubectl get nodes
#    fi
#    sleep 1
# done

/opt/create-pv.sh

kubectl patch storageclass fast -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Operator install
cd /home/cent/postgres-operator/installers/ansible
ansible-playbook -i inventory.yaml --tags=install main.yml

#now source the env variables for the client
source ~/.bashrc

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
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
      labels:
        name: weave-net
      namespace: kube-system
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: weave-net
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
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
          - networking.k8s.io
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
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: weave-net
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
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
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: weave-net
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
      labels:
        name: weave-net
      namespace: kube-system
    rules:
      - apiGroups:
          - ''
        resourceNames:
          - weave-net
        resources:
          - configmaps
        verbs:
          - get
          - update
      - apiGroups:
          - ''
        resources:
          - configmaps
        verbs:
          - create
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: weave-net
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
      labels:
        name: weave-net
      namespace: kube-system
    roleRef:
      kind: Role
      name: weave-net
      apiGroup: rbac.authorization.k8s.io
    subjects:
      - kind: ServiceAccount
        name: weave-net
        namespace: kube-system
  - apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: weave-net
      annotations:
        cloud.weave.works/launcher-info: |-
          {
            "original-request": {
              "url": "/k8s/v1.10/net.yaml?k8s-version=v1.16.0",
              "date": "Mon Oct 28 2019 18:38:09 GMT+0000 (UTC)"
            },
            "email-address": "support@weave.works"
          }
      labels:
        name: weave-net
      namespace: kube-system
    spec:
      minReadySeconds: 5
      selector:
        matchLabels:
          name: weave-net
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
              image: 'docker.io/weaveworks/weave-kube:2.6.0'
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
            - name: weave-npc
              env:
                - name: HOSTNAME
                  valueFrom:
                    fieldRef:
                      apiVersion: v1
                      fieldPath: spec.nodeName
              image: 'docker.io/weaveworks/weave-npc:2.6.0'
              resources:
                requests:
                  cpu: 10m
              securityContext:
                privileged: true
              volumeMounts:
                - name: xtables-lock
                  mountPath: /run/xtables.lock
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
cat <<EOF > /home/cent/postgres-operator/installers/ansible/values.yaml
# =====================
# Configuration Options
# More info for these options can be found in the docs
# https://access.crunchydata.com/documentation/postgres-operator/latest/installation/configuration/
# =====================
archive_mode: "true"
archive_timeout: "60"
backrest_aws_s3_bucket: ""
backrest_aws_s3_endpoint: ""
backrest_aws_s3_key: ""
backrest_aws_s3_region: ""
backrest_aws_s3_secret: ""
backrest_aws_s3_uri_style: ""
backrest_aws_s3_verify_tls: "true"
backrest_gcs_bucket: ""
backrest_gcs_endpoint: ""
backrest_gcs_key_type: ""
backrest_port: "2022"
badger: "false"
ccp_image_prefix: "registry.developers.crunchydata.com/crunchydata"
ccp_image_pull_secret: ""
ccp_image_pull_secret_manifest: ""
ccp_image_tag: "centos8-13.3-4.7.1"
create_rbac: "true"
crunchy_debug: "false"
db_name: "workshop"
db_password_age_days: "0"
db_password_length: "24"
db_port: "5432"
db_replicas: "0"
db_user: "normaluser"
default_instance_memory: "128Mi"
default_pgbackrest_memory: "48Mi"
default_pgbouncer_memory: "24Mi"
default_exporter_memory: "24Mi"
delete_operator_namespace: "false"
delete_watched_namespaces: "false"
disable_auto_failover: "false"
reconcile_rbac: "true"
exporterport: "9187"
metrics: "false"
namespace: "pgo"
namespace_mode: "dynamic"
pgbadgerport: "10000"
pgo_add_os_ca_store: "false"
pgo_admin_password: "examplepassword"
pgo_admin_perms: "*"
pgo_admin_role_name: "pgoadmin"
pgo_admin_username: "admin"
pgo_apiserver_port: "8443"
pgo_apiserver_url: "https://postgres-operator"
pgo_client_cert_secret: "pgo.tls"
pgo_client_container_install: "false"
pgo_client_install: "true"
pgo_client_version: "4.7.1"
pgo_cluster_admin: "false"
pgo_disable_eventing: "false"
pgo_disable_tls: "false"
pgo_image_prefix: "registry.developers.crunchydata.com/crunchydata"
pgo_image_pull_secret: ""
pgo_image_pull_secret_manifest: ""
pgo_image_tag: "centos8-4.7.1"
pgo_installation_name: "devtest"
pgo_noauth_routes: ""
pgo_operator_namespace: "pgo"
pgo_tls_ca_store: ""
pgo_tls_no_verify: "false"
pod_anti_affinity: "preferred"
pod_anti_affinity_pgbackrest: ""
pod_anti_affinity_pgbouncer: ""
scheduler_timeout: "3600"
service_type: "ClusterIP"
sync_replication: "false"
backrest_storage: "default"
backup_storage: "default"
primary_storage: "default"
replica_storage: "default"
pgadmin_storage: "default"
wal_storage: ""
storage1_name: "default"
storage1_access_mode: "ReadWriteOnce"
storage1_size: "1G"
storage1_type: "dynamic"
storage2_name: "hostpathstorage"
storage2_access_mode: "ReadWriteMany"
storage2_size: "1G"
storage2_type: "create"
storage3_name: "nfsstorage"
storage3_access_mode: "ReadWriteMany"
storage3_size: "1G"
storage3_type: "create"
storage3_supplemental_groups: "65534"
storage4_name: "nfsstoragered"
storage4_access_mode: "ReadWriteMany"
storage4_size: "1G"
storage4_match_labels: "crunchyzone=red"
storage4_type: "create"
storage4_supplemental_groups: "65534"
storage5_name: "storageos"
storage5_access_mode: "ReadWriteOnce"
storage5_size: "5Gi"
storage5_type: "dynamic"
storage5_class: "fast"
storage6_name: "primarysite"
storage6_access_mode: "ReadWriteOnce"
storage6_size: "4G"
storage6_type: "dynamic"
storage6_class: "primarysite"
storage7_name: "alternatesite"
storage7_access_mode: "ReadWriteOnce"
storage7_size: "4G"
storage7_type: "dynamic"
storage7_class: "alternatesite"
storage8_name: "gce"
storage8_access_mode: "ReadWriteOnce"
storage8_size: "300M"
storage8_type: "dynamic"
storage8_class: "standard"
storage9_name: "rook"
storage9_access_mode: "ReadWriteOnce"
storage9_size: "1Gi"
storage9_type: "dynamic"
storage9_class: "rook-ceph-block"
EOF


cat <<EOF >> ~/.bashrc
export PGOUSER="${HOME?}/.pgo/pgo/pgouser"
export PGO_CA_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_KEY="${HOME?}/.pgo/pgo/client.key"
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PGO_CMD='kubectl'
export PGO_OPERATOR_NAMESPACE='pgo'
EOF
