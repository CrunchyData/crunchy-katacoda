#!/usr/bin/bash

# Runs in the background

adduser training
echo "training" | passwd training --stdin
usermod -aG wheel training
echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cat > pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    training        replica_user    127.0.0.1/32   scram-sha-256

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
EOF

/usr/bin/cp /var/lib/pgsql/12/data/pg_hba.conf /var/lib/pgsql/12/data/pg_hba.conf.orig
chown postgres:postgres /var/lib/pgsql/12/data/pg_hba.conf.orig
/usr/bin/cp -f pg_hba.conf /var/lib/pgsql/12/data/pg_hba.conf  

systemctl enable postgresql-12
systemctl start postgresql-12

sudo -Hiu postgres psql -U postgres -c "ALTER SYSTEM SET password_encryption = 'scram-sha-256'"
sudo systemctl restart postgresql-12
sudo -Hiu postgres psql -U postgres -c "CREATE ROLE training WITH LOGIN SUPERUSER"
sudo -Hiu postgres psql -U postgres -c "CREATE ROLE replica_user WITH LOGIN REPLICATION PASSWORD '12345'"

sudo -u postgres psql -U postgres -c "CREATE DATABASE training"
sudo -u postgres psql -U postgres -c "ALTER DATABASE training OWNER TO training"

sudo -Hiu postgres mkdir /var/lib/pgsql/12/subdb
sudo -Hiu postgres chmod 700 /var/lib/pgsql/12/subdb
sudo -Hiu postgres /usr/pgsql-12/bin/initdb -D /var/lib/pgsql/12/subdb -k 
sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/12/subdb/postgresql.conf
sudo -Hiu postgres /usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/subdb start

sudo -Hiu postgres psql -U postgres -p 5444 -c "CREATE ROLE training WITH LOGIN SUPERUSER"
sudo -Hiu postgres psql -U postgres -p 5444 -c "CREATE DATABASE training"

systemctl restart postgresql-12
