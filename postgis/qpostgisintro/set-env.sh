#!/usr/bin/bash

#runs in foreground

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev && sleep 8

unzip

echo 'loading storm center points'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_locations (episode_id, event_id, location_index, range, azimuth, location, latitude, longitude, the_geom) from '\''/data/crunchy_demo_data/storms/storm_locations_copy.txt'\'' WITH CSV QUOTE '\''"'\'' '
echo 'finished storm center points'

echo 'ready to go!'