#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev && sleep 8

echo 'loading storm center points'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_details from '\''/data/crunchy_demo_data/storms/StormEvents_details-ftp_v1.0_d2018_c20190130.csv'\'' WITH CSV HEADER'

echo 'finished storm center points'

clear

echo 'ready to go!'