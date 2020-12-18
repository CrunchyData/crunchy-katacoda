#!/usr/bin/bash

#runs in foreground

echo 'please wait while we prep the environment (should take about 10 seconds)'

cat <<EOF > ~/.pgpass
localhost:5432:tampa:groot:password
localhost:5432:workshop:groot:password
EOF

sudo chmod 0600 ~/.pgpass

echo 'starting the database'
docker network create mybridge
docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql crunchydata/crunchy-postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'create demo database'
PGPASSWORD="password" psql -h localhost -U postgres -c 'CREATE DATABASE tampa WITH OWNER = groot'

echo 'DB created'

clear

: 'ready to go!'