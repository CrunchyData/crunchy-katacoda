#!/usr/bin/bash

#runs in foreground

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev 

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'loading storm center points'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/boundaries/county_boundaries.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_locations (episode_id, event_id, location_index, range, azimuth, location, latitude, longitude, the_geom) from '\''/data/crunchy_demo_data/storms/storm_locations_copy.txt'\'' WITH CSV QUOTE '\''"'\'' '
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY county_geometry (statefp, countyfp, countyns, geoid, county_name, namelsad, funcstat, aland, awater, interior_pnt, the_geom) from '\''/data/crunchy_demo_data/boundaries/county_boundaries_copy.txt'\'' WITH CSV QUOTE '\''"'\'' '
echo 'finished storm center points'

: 'ready to go!'