#!/usr/bin/bash

# Runs in the background

adduser training
echo "training" | passwd training --stdin
usermod -aG wheel training
echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


cat > pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    replication    replica_user    127.0.0.1/32    md5
host    replication    training       127.0.0.1/32    trust

local   training        all                           trust
host    training        all           127.0.0.1/32    trust

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident
EOF

/usr/bin/cp /var/lib/pgsql/11/data/pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf.orig
chown postgres:postgres /var/lib/pgsql/11/data/pg_hba.conf.orig
/usr/bin/cp -f pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf  

systemctl enable postgresql-11
systemctl start postgresql-11

sudo -u postgres psql -U postgres -c "CREATE ROLE training WITH LOGIN SUPERUSER"

sudo -u postgres psql -U postgres -c "CREATE DATABASE training"
sudo -u postgres psql -U postgres -c "ALTER DATABASE training OWNER TO training"

sudo -u training psql -c "CREATE TABLE example1 (id bigint, stuff text)"
sudo -u training psql -c "INSERT INTO example1 (id, stuff) VALUES (generate_series(1,20), 'stuff'||generate_series(1,20))"
sudo -u training psql -c "CREATE TABLE example2 (id bigint, stuff text)"
sudo -u training psql -c "INSERT INTO example2 (id, stuff) VALUES (generate_series(1,20), 'stuff'||generate_series(1,20))"
sudo -u training psql -c "ALTER TABLE example1 OWNER TO training" 
sudo -u training psql -c "ALTER TABLE example2 OWNER TO training" 


sudo -u training psql -c "ALTER SYSTEM SET archive_mode = 'on'"
sudo -u training psql -c "ALTER SYSTEM SET archive_command = '/bin/true'"

systemctl restart postgresql-11
