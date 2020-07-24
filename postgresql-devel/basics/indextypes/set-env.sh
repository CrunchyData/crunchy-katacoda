#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge

docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql crunchydata/crunchy-postgres-appdev:latest

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done
PGPASSWORD="password" psql -h localhost -U groot -p 5432 -c 'CREATE EXTENSION IF NOT EXISTS "pgcrypto";' workshop


echo 'loading data'
gunzip -c /data/crunchy-demo-data.dump.sql.gz | PGPASSWORD="password" psql -h localhost -U groot -p 5432 workshop

echo 'finished loading data'


PGPASSWORD="password" psql -h localhost -U groot workshop