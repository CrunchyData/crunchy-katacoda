echo "Installing required packages"

echo 'adding postgres rpm'
yum install -y yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm

echo 'installing postgres and backrest'
yum install -y postgresql11 pgbackrest postgresql-contrib

postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql

echo "Pull Docker Images"
docker pull crunchydata/crunchy-postgres:centos7-11.2-2.3.1
docker pull crunchydata/crunchy-pgadmin4:centos7-11.2-2.3.1
