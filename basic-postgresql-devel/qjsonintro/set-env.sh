#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'loading wikipedia data'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/natural_events/natural_events.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY natural_events from '\''/data/crunchy_demo_data/natural_events/natural_events.csv'\'' WITH DELIMITER '\''|'\'' '
echo 'finished wikipedia boundaries'
: 'ready to go!'