#!/usr/bin/bash

# Runs in the background

adduser training
echo "training" | passwd training --stdin
usermod -aG wheel training
echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cat > pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD

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

sudo -u postgres psql -U postgres -c "CREATE ROLE training WITH LOGIN SUPERUSER"

sudo -u postgres psql -U postgres -c "CREATE DATABASE training"
sudo -u postgres psql -U postgres -c "ALTER DATABASE training OWNER TO training"

systemctl restart postgresql-12
