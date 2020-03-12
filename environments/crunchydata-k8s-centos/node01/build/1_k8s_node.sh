set -e
sudo yum remove -y docker docker-common

sudo rpm --import https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi
sudo yum

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io unzip nano postgresql12
systemctl enable --now docker
systemctl start docker

echo '127.0.0.1 node01' >> /etc/hosts
hostname node01 && echo node01 > /etc/hostname
hostnamectl set-hostname node01

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
sudo kubeadm config images pull
sudo docker pull weaveworks/weave-kube:2.5.1
sudo docker pull weaveworks/weave-npc:2.5.1

#now operator stuff

sudo docker pull crunchydata/crunchy-backrest-restore:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-collect:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgrestore:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgadmin4:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-backup:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgbadger:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgbasebackup-restore:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgbouncer:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgdump:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-pgpool:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-grafana:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-prometheus:centos7-12.2-4.2.2

sudo docker pull crunchydata/pgo-event:centos7-4.2.2
sudo docker pull crunchydata/pgo-scheduler:centos7-4.2.2
sudo docker pull crunchydata/pgo-backrest-repo:centos7-4.2.2
sudo docker pull crunchydata/pgo-backrest-restore:centos7-4.2.2
sudo docker pull crunchydata/pgo-backrest:centos7-4.2.2
sudo docker pull crunchydata/pgo-backrest-repo-sync:centos7-4.2.2
sudo docker pull crunchydata/pgo-client:centos7-4.2.2
sudo docker pull crunchydata/pgo-load:centos7-4.2.2
sudo docker pull crunchydata/pgo-rmdata:centos7-4.2.2
sudo docker pull crunchydata/pgo-sqlrunner:centos7-4.2.2
sudo docker pull crunchydata/crunchy-admin:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-postgres-ha:centos7-12.2-4.2.2
sudo docker pull crunchydata/crunchy-postgres-gis-ha:centos7-12.2-4.2.2
