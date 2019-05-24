#!/usr/bin/bash

echo 'Please wait while we prep the environment (should take about 10 seconds)'
echo 'Starting the database...'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=nyc --name=pgsql thesteve0/postgres-appdev && sleep 8

echo 'Loading data...'
curl http://s3.cleverelephant.ca/nyc_data.sql.gz | gzip -dc | PGPASSWORD="password" psql -h localhost -U groot nyc

echo 'Finished and ready to go.'
PGPASSWORD="password" psql -h localhost -U groot nyc