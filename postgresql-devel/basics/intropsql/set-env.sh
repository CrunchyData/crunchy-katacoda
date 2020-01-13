#!/usr/bin/bash

echo 'please wait while we prep the environment (should take about 10 seconds)'
echo 'starting the database'
docker network create mybridge
docker run -d --network mybridge -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev

until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'loading storm center points'
PGPASSWORD="password" psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop
PGPASSWORD="password" psql -h localhost -U groot -d workshop -c '\COPY se_details from '\''/data/crunchy_demo_data/storms/StormEvents_details-ftp_v1.0_d2018_c20190130.csv'\'' WITH CSV HEADER'

echo 'finished storm center points'

cat <<EOF > test_create_and_copy.sql
-- Partial copy of se_details table
CREATE TABLE cp_se_details AS
SELECT
    *
FROM se_details
WHERE month_name = 'June';

-- Create another table and insert some data
CREATE TABLE new_test_table (
    id  SERIAL  PRIMARY KEY,
    hero_name   VARCHAR (80),
    cohort  integer 
);
INSERT INTO new_test_table (hero_name, cohort)
VALUES  ('Iron Man', 1),
        ('Captain Marvel', 3),
        ('Incredible Hulk', 1),
        ('Black Panther', 2),
        ('Black Widow', 3);

-- Display contents of new table
SELECT * FROM new_test_table;
EOF

clear

: 'ready to go!'