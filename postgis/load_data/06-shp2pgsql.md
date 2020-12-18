### 2. Pipe shp2pgsql output to psql

Sometimes, you may not need nor want to first redirect shp2pgsql's output to a 
file. An even quicker method of getting data into Postgres is to just pipe the 
output into psql. This time we'll import a different shapefile containing 
data on sidewalks throughout the City of Tampa:

```
\q

shp2pgsql -s 4326 -I /data/tpa/Sidewalk.shp | psql -U groot -h localhost tampa
 ```{{execute}}

The pipe `|` operator allows you to convert and import the shapefile data in 
one step. This is a larger dataset, so make sure that you wait until you see 
the last SQL command `COMMIT` and that you are taken back to the terminal 
before logging back in to Postgres.

```
psql -U groot -h localhost tampa
```{{execute}}

You may have noticed that the parking garages and lots are Point geometries. How are 
sidewalks represented? Take a guess and try checking with `\d sidewalk`, or:

```
SELECT ST_GeometryType(geom) FROM sidewalk LIMIT 1;
```{{execute}}
