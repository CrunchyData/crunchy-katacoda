#!/bin/bash

echo "Installing required packages"

echo 'adding postgres rpm'
yum install -y yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm

echo 'installing postgres and backrest'
yum install -y postgresql11 postgresql11-server  pgbackrest postgresql-contrib postgis25_11 pgadmin4 unzip
/usr/pgsql-11/bin/postgresql-11-setup initdb


echo "Pull Docker Images"
docker pull crunchydata/crunchy-postgres:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-postgres-gis:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-pgadmin4:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-pgpool:centos7-11.2-2.3.1
docker pull thesteve0/postgres-appdev

echo "Downloading sample data"
cd /tmp
wget https://github.com/thesteve0/crunchydemodata/releases/download/v0.1/crunchy_demo_data_v0.1.zip
mkdir /data
chmod 777 /data
unzip crunchy_demo_data_v0.1.zip -d /data
rm -f crunchy_demo_data_v0.1.zip
