#!/usr/bin/bash

#runs in foreground

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge
docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql crunchydata/crunchy-postgres-appdev

clear

: 'ready to go!'