set -e

# Reset our cache and then recreate
# Cleans out old repo information
yum clean all
yum makecache

sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi

sudo yum install -y postgresql12

# Operator Work Now - we should go all the way through and actually put the operator into the cluster
# This means we will need to spin up the cluster install and then shut it down cleanly
echo Setting up the operator
sudo yum install -y ansible
cd /home/cent
git clone https://github.com/CrunchyData/postgres-operator.git
cd postgres-operator
git checkout v4.7.1
cd ansible

echo "Pull recent docker images"
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgadmin4:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbadger:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbouncer:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest-repo:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-ha:centos8-12.7-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-gis-ha:centos8-12.7-3.0-4.7.1

sudo docker pull registry.developers.crunchydata.com/crunchydata/postgres-operator:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-apiserver:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-event:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-scheduler:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-client:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-rmdata:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/pgo-deployer:centos8-4.7.1
sudo docker pull registry.developers.crunchydata.com/crunchydata/crunchy-postgres-exporter:centos8-4.7.1
