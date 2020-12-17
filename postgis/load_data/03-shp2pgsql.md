## Shapefiles

### What is a shapefile?

[Shapefiles] are a very common format developed by Esri for storing and 
transporting spatial data. When we talk about a "shapefile," it usually 
refers to a collection of files and not just a single file with the `.shp` 
extension. We've taken a look at the `.prj` file in the previous section. 
The [Intro to PostGIS tutorial](https://postgis.net/workshops/postgis-intro/loading_data.html#shapefiles-what-s-that) 
also has helpful information about shapefiles.

### shp2pgsql for importing shapefiles into PostGIS

`shp2pgsql` is a command line tool for importing shapefiles into a PostgreSQL/PostGIS 
database. shp2pgsql comes with a PostGIS install, so we should already be able 
to run it in our environment. Let's make sure we log out of `psql` first:

```
\q
```{{execute}}

Now try running the following in the command prompt:

```
shp2pgsql -?
```

The `-?` flag displays the help menu which shows the different options or flags 
you can use with the command. You can also find a comprehensive list in the 
[official PostGIS docs](https://postgis.net/docs/using_postgis_dbmanagement.html#loading_geometry_data).

`shp2pgsql` basically converts shapefiles to SQL, which can then be run by Postgres 
to insert spatial data. So if you try running the `shp2pgsql` command like this:
`shp2pgsql -s 4326 myshapefile.shp`, you'll get a bunch of SQL statements in 
the terminal as output. More commonly, you'd do either one of the following:

### 1. Redirect shp2pgsql output to a SQL file

We have a shapefile in the /data/tpa/TPA_Parking_Garages directory in our 
environment, containing data about [parking garages and lots](https://city-tampa.opendata.arcgis.com/datasets/parking-garages-and-lots) throughout downtown
 Tampa. We'll use `shp2pgsql` to first save this information in a SQL script,
  then use `psql` to run the script.

```
shp2pgsql -s 4326 -I /data/tpa/TPA_Parking_Garages/Parking_Garages_and_Lots.shp > parking_garages_lots.sql
```{{execute}}

1. By default, a new table `parking_garages_and_lots` is created and populated 
from the shapefile. This table will include a `geometry` column.
2. `-s 4326`: the SRID `4326` ([WGS 84](https://spatialreference.org/ref/epsg/wgs-84/)) 
is set for the `geometry` column.
3. `-I` creates a [GiST index](https://www.postgresql.org/docs/current/gist-intro.html)
 on `geometry`.
4. `/data/tpa/TPA_Parking_Garages/Parking_Garages_and_Lots.shp` is our source file.
5. `>` is an output redirection operator in *nix systems. This means that the 
SQL output from `shp2pgsql` is written to a file called `parking_garages_lots.sql`.

Let's take a look at the script:

```
nano parking_garages_lots.sql
```

Outputting to a file is useful not only for checking to see what the generated SQL is.
 You can also make any desired changes to the script before running it. 
 (Exit out of `nano` by hitting Ctrl + O to save changes you make, then Ctrl + X.)

When you're ready to import the data, run this `psql` statement:

```
psql -U groot -h localhost -d tampa -f parking_garages_lots.sql
```

The `-f` flag tells `psql` to [read commands](https://www.postgresql.org/docs/current/app-psql.html) 
from the given file. 

(We have a course on [loading data into Postgres](https://learn.crunchydata.com/postgresql-devel/courses/basics/import)
 if you want a bit more practice with `psql -f`.)

Let's take a glance at our new table:

```
psql -U groot -h localhost tampa

SELECT spacename, fulladdr FROM parking_garages_and_lots;
```{{execute}}

### 2. Pipe shp2pgsql output to psql

Sometimes, you may not need nor want to first redirect shp2pgsql's output to a 
file. An even quicker method of getting data into Postgres is to just pipe the 
output into psql:

```
\q

shp2pgsql -s 4326 -I /data/tpa/TPA_Sidewalk/Sidewalk.shp | psql -U groot -h localhost tampa
 ```{{execute}}

The pipe `|` operator allows you to convert and import the shapefile data in 
one step. How many records do we end up with in our new `sidewalk` table?

```
SELECT COUNT(*) FROM sidewalk;
```
