#!/usr/bin/bash

#runs in foreground

adduser training
echo "training" | passwd training --stdin

cat > pg_hba.conf << EOF
# TYPE  DATABASE       USER           ADDRESS         METHOD
host    replication    replica_user    127.0.0.1/32   trust
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

sudo systemctl enable postgresql-11
sudo systemctl start postgresql-11

sudo -u postgres psql -U postgres -c "CREATE ROLE root WITH LOGIN SUPERUSER"
sudo -u postgres psql -U postgres -c "CREATE ROLE training WITH LOGIN"

sudo -u postgres psql -U postgres -c "CREATE DATABASE root"
sudo -u postgres psql -U postgres -c "CREATE DATABASE training"
sudo -u postgres psql -U postgres -c "ALTER DATABASE training OWNER TO training"

sudo -u postgres psql -U training -c "CREATE TABLE example1 (id bigint, stuff text)"
sudo -u postgres psql -U training -c "INSERT INTO example1 (id, stuff) VALUES (generate_series(1,20), 'stuff'||generate_series(1,20))"
sudo -u postgres psql -U training -c "CREATE TABLE example2 (id bigint, stuff text)"
sudo -u postgres psql -U training -c "INSERT INTO example2 (id, stuff) VALUES (generate_series(1,20), 'stuff'||generate_series(1,20))"
sudo -u postgres psql -U training -c "ALTER TABLE example1 OWNER TO training" 
sudo -u postgres psql -U training -c "ALTER TABLE example2 OWNER TO training" 

sudo -u postgres psql -c "CREATE ROLE replica_user WITH LOGIN REPLICATION PASSWORD 'password'"

psql -c "ALTER SYSTEM SET archive_mode = 'on'"
psql -c "ALTER SYSTEM SET archive_command = 'pgbackrest archive-push --stanza=main %p'"

psql -c "SELECT * FROM pg_create_physical_replication_slot('training_replica')"

systemctl restart postgresql-11

sudo -u postgres pg_basebackup -h 127.0.0.1 -U replica_user -D /var/lib/pgsql/11/replica -R -Xs -P -S training_replica -v

sed -i "/port = 5432/c\port = 5444" /var/lib/pgsql/11/replica/postgresql.conf

sudo -u postgres /usr/pgsql-11/bin/pg_ctl -D /var/lib/pgsql/11/replica start

psql -p 5444 -c "ALTER SYSTEM SET archive_command = 'pgbackrest archive-push --stanza=new-primary %p'"

psql -p 5444 -c "SELECT pg_reload_conf()"

yum install -y pgbackrest

cat > /etc/pgbackrest.conf << EOF
[global]
repo1-path=/var/lib/pgbackrest
log-level-console=info
retention-full=2

[main]
pg1-path=/var/lib/pgsql/11/data
pg1-port=5432

[new-primary]
pg1-path=/var/lib/pgsql/11/replica
pg1-port=5444
recovery-option=standby_mode=on
recovery-option=primary_conninfo=host=127.0.0.1 port=5444 user=replica_user password=password
recovery-option=primary_slot_name=training_replica

EOF

sudo -u postgres pgbackrest --stanza=main stanza-create --log-level-console=error
sudo -u postgres pgbackrest --stanza=new-primary stanza-create --log-level-console=error

clear
