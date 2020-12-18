## What is a shapefile?

[Shapefiles](https://en.wikipedia.org/wiki/Shapefile) are a very common format developed by Esri for storing and 
transporting spatial data.

When we talk about a "shapefile," we're usually 
referring to a collection of files and not just a single file with the `.shp` 
extension. We've seen the `.prj` file in the previous section. 
The [Intro to PostGIS tutorial](https://postgis.net/workshops/postgis-intro/loading_data.html#shapefiles-what-s-that) 
also has helpful information about shapefiles.

## shp2pgsql for importing shapefiles into PostGIS

`shp2pgsql` is a command line tool for importing shapefiles into a PostgreSQL/PostGIS 
database. shp2pgsql comes with a PostGIS install, so we should already be able 
to run it in our environment. Let's make sure we log out of `psql` first:

```
\q
```{{execute}}

Now try running the following in the command prompt:

```
shp2pgsql -?
```{{execute}}

The `-?` flag displays the help menu which shows the different options or flags 
you can use with the command. You can also find a comprehensive list in the 
[official PostGIS docs](https://postgis.net/docs/using_postgis_dbmanagement.html#loading_geometry_data).

`shp2pgsql` basically converts shapefiles to SQL, which can then be run by Postgres 
to insert spatial data. If you try running the `shp2pgsql` command like this:
`shp2pgsql -s 4326 myshapefile.shp`, you'll get a bunch of SQL statements in 
the terminal as output. More common ways of using `shp2pgsql` would be either one of the following:

### 1. Redirect shp2pgsql output to a SQL file

We have a shapefile in our /data/tpa/ directory that contains data about 
[parking garages and lots](https://city-tampa.opendata.arcgis.com/datasets/parking-garages-and-lots)
 throughout downtown Tampa. We'll use `shp2pgsql` to first save the output in a SQL script,
  then use `psql` to run the script.

```
shp2pgsql -s 4326 -I /data/tpa/Parking_Garages_and_Lots.shp > parking_garages_lots.sql
```{{execute}}

1. By default, a new table `parking_garages_and_lots` is created and populated 
from the shapefile. This table will include a `geom` column.
2. `-s 4326`: the SRID `4326` (WGS 84) is set for the `geometry` column.
3. `-I` creates a [GiST index](https://www.postgresql.org/docs/current/gist-intro.html)
 on `geometry`.
4. `/data/tpa/Parking_Garages_and_Lots.shp` is our source file.
5. `>` is an output redirection operator in *nix systems. We'll get the SQL 
output from `shp2pgsql` written to a file called `parking_garages_lots.sql`.

Let's take a look at the script:

```
nano parking_garages_lots.sql
```{{execute}}

Outputting to a file is useful not only for checking to see what the generated SQL is.
 You can also make any desired changes to the script before running it. 
 (Exit out of `nano` by hitting Ctrl + O to save changes you make, then Ctrl + X.)

When you're ready to import the data, run this `psql` statement:

```
psql -U groot -h localhost -d tampa -f parking_garages_lots.sql
```{{execute}}

The `-f` flag tells `psql` to [read commands](https://www.postgresql.org/docs/current/app-psql.html) 
from the given file. (We have a course on [loading data into Postgres](https://learn.crunchydata.com/postgresql-devel/courses/basics/import) if you want a bit more practice with `psql -f`.)

Let's log in to Postgres and try querying our new table:

```
psql -U groot -h localhost tampa
```{{execute}}
```
\d parking_garages_and_lots
```{{execute}}
```
SELECT spacename, fulladdr FROM parking_garages_and_lots;
```{{execute}}

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
