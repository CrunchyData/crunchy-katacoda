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
database. `shp2pgsql` comes with a PostGIS install, so we should already be able 
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
the terminal as output. 
