#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge

docker run -d --network mybridge -p 5050:5050 -e PGADMIN_SETUP_EMAIL=admin -e PGADMIN_SETUP_PASSWORD=password --name=pgadmin crunchydata/crunchy-pgadmin4:centos7-11.4-2.4.1

docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_locations (episode_id, event_id, location_index, range, azimuth, location, latitude, longitude, the_geom) from '\''/data/crunchy_demo_data/storms/storm_locations_copy.txt'\'' WITH CSV QUOTE '\''"'\'' '

PGPASSWORD="password" psql -h localhost -U groot workshop