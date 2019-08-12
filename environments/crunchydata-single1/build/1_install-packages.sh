 #!/bin/bash

echo "Installing required packages"

echo 'prepping to add rpms'

rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm --import http://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG-10
rpm --import http://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG-11

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install EPEL Repo"
    exit 1
fi


yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres Repo"
    exit 1
fi

echo 'installing RPMs'
yum install -y postgresql11 postgresql11-server  pgbackrest postgresql11-contrib postgis25_11 pgadmin4 R unzip nano
if [ "$?" -ne 0 ]; then
    echo "Unable to install Postgres"
    exit 1
fi

/usr/pgsql-11/bin/postgresql-11-setup initdb

echo "Pull Docker Images"
docker pull crunchydata/crunchy-postgres:centos7-11.4-2.4.1
docker pull crunchydata/crunchy-postgres-gis:centos7-11.4-2.4.1
docker pull crunchydata/crunchy-pgadmin4:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-pgpool:centos7-11.4-2.4.1 
docker pull thesteve0/postgres-appdev

echo "Downloading sample data"
cd /tmp
wget https://github.com/CrunchyData/crunchy-demo-data/releases/download/v0.3/crunchy_demo_data_v0.3.zip
mkdir /data
chmod 777 /data
unzip -u crunchy_demo_data_v0.3.zip -d /data
rm -f crunchy_demo_data_v0.3.zip
