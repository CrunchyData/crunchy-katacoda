set -e

sudo yum install -y postgresql12

# Operator Work Now - we should go all the way through and actually put the operator into the cluster
# This means we will need to spin up the cluster install and then shut it down cleanly
echo Setting up the operator
sudo yum install -y ansible
cd /home/cent
git clone https://github.com/CrunchyData/postgres-operator.git
cd postgres-operator
git checkout v4.2.2
cd ansible


echo "Pull recent docker images"
# not including upgrade,pgbasebackup-restore
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

sudo docker pull crunchydata/postgres-operator:centos7-4.2.2
sudo docker pull crunchydata/pgo-apiserver:centos7-4.2.2
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

