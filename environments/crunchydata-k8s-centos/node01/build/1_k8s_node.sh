set -e
sudo rpm --import https://api.developers.crunchydata.com/downloads/gpg/RPM-GPG-KEY-crunchydata-dev
sudo yum install -y https://api.developers.crunchydata.com/downloads/repo/rpm-centos/postgresql12/crunchypg12.repo
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi

sudo yum install -y postgresql12

sudo docker pull storageos/node:1.5.0

#now operator stuff

sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgadmin4:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbadger:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbouncer:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest-repo:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-ha:centos8-12.7-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-gis-ha:centos8-12.7-3.0-4.7.0

sudo docker pull registry.developers.crunchydata.com/crunchydata/postgres-operator:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-apiserver:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-event:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-scheduler:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-client:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-rmdata:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-deployer:centos8-4.7.0
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-exporter:centos8-4.7.0
