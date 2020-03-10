#!/bin/bash

echo "Installing required packages"

echo 'prepping to add rpms'

sudo rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
sudo rpm --import https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG


yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install EPEL Repo"
    exit 1
fi


sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi

echo 'installing RPMs'
sudo yum install -y postgresql11 postgresql11-server postgresql12 postgresql12-server postgresql12-contrib pgbackrest postgresql11-contrib postgis25_11 R unzip nano
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres"
    exit 1
fi

/usr/pgsql-11/bin/postgresql-11-setup initdb
/usr/pgsql-12/bin/postgresql-12-setup initdb


echo "OLD Pull Docker Images - leave in until we update all the scenarios"
docker pull crunchydata/crunchy-postgres:centos7-11.4-2.4.1
docker pull crunchydata/crunchy-postgres-gis:centos7-11.4-2.4.1
docker pull crunchydata/crunchy-pgadmin4:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-pgpool:centos7-11.4-2.4.1 
docker pull thesteve0/postgres-appdev

echo "Pull recent docker images"
# not including upgrade,pgbasebackup-restore
docker pull crunchydata/crunchy-backrest-restore:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-collect:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgrestore:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-postgres:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-postgres-gis:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgadmin4:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-backup:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgbadger:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgbasebackup-restore:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgbouncer:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgdump:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-pgpool:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-grafana:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-prometheus:centos7-12.2-4.2.2
docker pull crunchydata/crunchy-postgres-appdev:latest




echo "Downloading sample data"
cd /tmp
wget https://github.com/CrunchyData/crunchy-demo-data/releases/download/v0.3/crunchy_demo_data_v0.3.zip
mkdir /data
chmod 777 /data
unzip -u crunchy_demo_data_v0.3.zip -d /data
rm -f crunchy_demo_data_v0.3.zip
