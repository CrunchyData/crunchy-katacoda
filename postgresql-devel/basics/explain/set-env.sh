#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge

docker run -d --network mybridge -p 5050:5050 -e PGADMIN_SETUP_EMAIL=admin -e PGADMIN_SETUP_PASSWORD=password --name=pgadmin crunchydata/crunchy-pgadmin4:centos7-11.2-2.3.1

docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'loading storm data'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_details from '\''/data/crunchy_demo_data/storms/StormEvents_details-ftp_v1.0_d2018_c20190130.csv'\'' WITH CSV HEADER'
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\copy se_fatalities from '\''/data/crunchy_demo_data/storms/StormEvents_fatalities-ftp_v1.0_d2018_c20190130.csv'\'' with CSV HEADER';

echo 'finished storm data'


PGPASSWORD="password" psql -h localhost -U groot workshop