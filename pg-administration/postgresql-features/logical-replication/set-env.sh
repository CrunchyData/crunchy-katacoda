#!/usr/bin/bash

#runs in foreground

adduser training
echo "training" | passwd training --stdin

cat > /var/lib/pgsql/11/data/pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    root        replica_user    127.0.0.1/32   scram-sha-256

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident
EOF

sudo systemctl enable postgresql-11
sudo systemctl start postgresql-11

sudo -Hiu postgres psql -U postgres -c "ALTER SYSTEM SET password_encryption = 'scram-sha-256'"
sudo systemctl restart postgresql-11
sudo -Hiu postgres psql -U postgres -c "CREATE ROLE root WITH LOGIN SUPERUSER"
sudo -Hiu postgres psql -U postgres -c "CREATE ROLE replica_user WITH LOGIN REPLICATION PASSWORD '12345'"

sudo -Hiu postgres psql -U postgres -c "CREATE DATABASE root"

sudo -Hiu postgres mkdir /var/lib/pgsql/11/subdb
sudo -Hiu postgres chmod 700 /var/lib/pgsql/11/subdb
sudo -Hiu postgres /usr/pgsql-11/bin/initdb -D /var/lib/pgsql/11/subdb -k 
sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/11/subdb/postgresql.conf
sudo -Hiu postgres /usr/pgsql-11/bin/pg_ctl -D /var/lib/pgsql/11/subdb start

sudo -Hiu postgres psql -U postgres -p 5444 -c "CREATE ROLE root WITH LOGIN SUPERUSER"
sudo -Hiu postgres psql -U postgres -p 5444 -c "CREATE DATABASE root"



clear
