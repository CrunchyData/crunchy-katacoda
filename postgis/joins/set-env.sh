#!bash

echo 'Please wait while we prep the environment (should take about 10 seconds)'
echo 'Starting the database...'

docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=nyc --name=pgsql crunchydata/crunchy-postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'Loading data...'
curl http://s3.cleverelephant.ca/nyc_data.sql.gz | gzip -dc | PGPASSWORD="password" psql -h localhost -U groot nyc

echo 'Finished and ready to go.'
clear
PGPASSWORD="password" psql -h localhost -U groot nyc
