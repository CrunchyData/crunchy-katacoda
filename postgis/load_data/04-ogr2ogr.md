Although shapefiles are a very common format in which to share spatial 
data, there are many other formats that you may need to work with as well. 
`shp2pgsql` is a go-to for shapefiles, but if you're dealing with another 
format, a tool called `ogr2ogr` is recommended. 

[ogr2ogr](https://gdal.org/programs/ogr2ogr.html) allows you to easily convert 
between GIS formats. Check out the list of supported formats,
 both for [vector data](https://gdal.org/drivers/vector/index.html) as well as 
 [raster](https://gdal.org/drivers/raster/index.html).
 And yes, `ogr2ogr` does work with shapefiles too. But `shp2pgsql` does make it
 a bit more straightforward to work with shapefiles + SQL if that's precisely 
 what you need.

## Import GeoJSON into PostGIS with ogr2ogr

In this exercise, we'll import data on [park polygons](https://city-tampa.opendata.arcgis.com/datasets/park-polygons?geometry=-83.779%2C27.778%2C-81.166%2C28.203) in the City of Tampa in 
[GeoJSON](https://en.wikipedia.org/wiki/GeoJSON) format. Go ahead and run the 
following command: 

(Make sure you're logged out of `psql` first by running `\q`):

```
ogr2ogr \
    -f PostgreSQL PG:"host=localhost user=groot password=password \
    dbname=tampa" /data/tpa/Park_Polygons.geojson \
    -nln park_polygons -lco GEOMETRY_NAME=geom
```{{execute}}

We'll now get a new table created in the `tampa` database. Let's
 review the command we just ran:
1. `-f`: We're specifying the output format `PostgreSQL`
2. We're providing a Postgres connection string `PG:"host=localhost user=groot password=password dbname=tampa"`
3. Our data source is in `/data/tpa/Park_Polygons.geojson`
4. `-nln`: We name our new table `park_polygons`
5. `-lco`: We're also passing in a `GEOMETRY_NAME` layer creation option. By default, the name of the 
geometry column in the new table will be `wkb_geometry`. But in this example 
we'll give it another name `geom`.

Layer creation options are format-specific. The list applicable to Postgres/PostGIS can 
be found on [this page](https://gdal.org/drivers/vector/pg.html).

Let's log in to Postgres and take a look around:

```
psql -U groot -h localhost tampa
```{{execute}}
```
\d park_polygons
```{{execute}}

We do see that we have a column named `geom` that has the `geometry` type, with 
the SRID has been set to 4326. Sometimes, `ogr2ogr` makes a wrong guess 
on the projection (see "When OGR guesses wrong": https://www.bostongis.com/PrinterFriendly.aspx?content_name=ogr_cheatsheet).
 (***Note on what kinds of scenarios makes this more frequent? And what to do to fix?)

Let's do a quick query:

```
SELECT ST_GeometryType(geom), count(ST_GeometryType(geom)) 
FROM park_polygons 
GROUP BY ST_GeometryType(geom);
```{{execute}}

The majority of our records in `park_polygons` are Polygons, but there are a 
handful that are MultiPolygons.
