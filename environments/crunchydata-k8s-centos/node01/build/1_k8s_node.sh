set -e
sudo rpm --import https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi

sudo yum install -y postgresql12

sudo docker pull storageos/node:1.5.0

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
