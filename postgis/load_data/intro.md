You may already be familiar with how to load data into "standard" 
PostgreSQL tables. Importing _spatial_ data in particular is a little different: you 
can certainly still use Postgres commands like `INSERT` or `\copy`, but you may
 also want to use special utilities to handle the import.  

If you have access to desktop GUIs, and deal with spatial data on a regular 
basis, [QGIS](https://qgis.org/en/site/) is a free and open source desktop client you might use to 
easily import spatial data into a PostGIS database. But in case you can't use a
 tool like QGIS, there are command-line options available. Using the 
 command line can also come in very handy for scripting and doing batch processes 
 with your data files.

This course will focus on **importing spatial data into PostGIS via the command 
line**. We'll be dealing with GIS vector data but in case you're not aware, there 
is [raster data](https://gisgeography.com/spatial-data-types-vector-raster/) as well.

In addition to `psql`, we'll be trying out `shp2pgsql` and `ogr2ogr`. If 
you're not familiar with `psql`, we strongly recommend checking out the [Intro to
psql course](https://learn.crunchydata.com/postgresql-devel/courses/basics/intropsql)
 first before you proceed.

This course also assumes that you've completed the previous courses in the 
PostGIS series: 
1. [Quick Introduction to PostGIS](https://learn.crunchydata.com/postgis/qpostgisintro/)
2. [Geometries](https://learn.crunchydata.com/postgis/geometries/)
3. [Geography](https://learn.crunchydata.com/postgis/geography/)

The data in this course is taken from the City of Tampa [Open Data GeoHub](https://city-tampa.opendata.arcgis.com/).
The data was downloaded in a few different GIS formats so you can see how you 
might choose or use an import tool depending on the format your spatial data is in.

PostGIS has already been installed in this environment. We'll mostly be using the following
 credentials to log in to Postgres:
- username: `groot`
- password: `password` (We've set up the environment so that you can log in via
`psql` without having to manually enter the password)
- database: `tampa`
We'll log in as a superuser in one instance (to run CREATE EXTENSION). Otherwise,
 it's best practice to avoid the superuser role when possible as it can bypass 
 almost every access restriction in the database!


Before we dive into PostGIS, let's also take a quick look at the 
background behind projections, and why it matters when it comes to importing 
spatial data. If you're new to spatial work, this will be useful context to 
have, even outside of PostGIS. 
