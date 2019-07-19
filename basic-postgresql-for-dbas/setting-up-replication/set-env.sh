#!/usr/bin/bash

#runs in foreground

cat > pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    replication    replication    127.0.0.1/32    md5
host    replication    training       127.0.0.1/32    trust

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident
EOF

/usr/bin/cp /var/lib/pgsql/11/data/pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf.orig
/usr/bin/cp -f pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf  

sudo systemctl enable postgresql-11
sudo systemctl start postgresql-11

sudo -u postgres psql -U postgres -c "CREATE ROLE root WITH LOGIN SUPERUSER"

sudo -u postgres psql -U postgres -c "CREATE DATABASE root"

psql -c "ALTER SYSTEM SET archive_mode = 'on'"
psql -c "ALTER SYSTEM SET archive_command = '/bin/true'"

sudo systemctl restart postgresql-11


