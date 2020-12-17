Spatial data allows you to model and position things, typically on the Earth's 
surface. But a value like POINT(-103.771555 44.967244) is practically 
meaningless without a **spatial reference system**. (You may also come across the 
term "coordinate system" used interchangeably in GIS.)
 
A spatial reference system is a framework for understanding a set of spatial 
data. It provides information such as units of measurement (e.g. degrees, 
meters, feet); whether the data represents a location on the Earth represented as a 
sphere _or_  projected out on a flat surface, like a map; and, if it's on a 
projection, how the "flattening" is done. So, as you may already know or have 
guessed, a spatial value could be valid across different spatial reference 
systems, but end up meaning entirely different things in each case. 

## Spatial reference systems and PostGIS

PostGIS comes with a list of spatial reference systems -- you can take a 
look at it by querying the `spatial_ref_sys` table. First, we'll log in to Postgres 
as user `groot`, toggle on extended display in the `psql` shell, then execute 
a SELECT query to return a single record (`srid = 4326`).

```
psql -U groot -h localhost workshop

\x

SELECT * FROM spatial_ref_sys WHERE srid = 26918;
```{{execute}}

In addition to having a frame of reference for a given set of spatial data, 
we also need to assign a spatial reference system to ensure that different 
datasets can "work" together. You may be using various reference systems across 
your database but your functions and queries will still work because PostGIS 
understands how to process your data. 

## Loading spatial data

When you load a spatial dataset into PostGIS, you'll either specify what 
spatial reference system to use, or it may be detected for you, depending on 
the import tool you use as well as the format the data came in. Generally 
you'll use the SRID (spatial reference identifier) to assign the reference 
system. Each reference system in `spatial_ref_sys` has an SRID.

### How do we know what SRID to use?

An organization called European Petroleum Survey Group put together a [database 
of coordinate systems](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
 and gave each system a unique number, known as an EPSG 
code. Most GIS software (PostGIS, QGIS, ArcGIS, etc) will understand the EPSG 
code to define the coordinate system.  

You might be able to confirm the SRID by examining the contents of your data 
file/s: for example, the `.prj` file if you have a shapefile. Let's give it a 
try.

```
\q

less /data/tpa/Parking_Garages_and_Lots.prj
```{{execute}}

We've logged out of `psql` and used the `less` command-line utility to check 
Parking_Garages_and_Lots.prj's contents. You should see a string that starts 
like this:

`GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984"...`

Let's do a search on the internet for "WGS 1984 EPSG" using the **Browser** 
tab in your interactive environment on the right. You should see results 
from pages such as [spatialreference.org](https://spatialreference.org/ref/epsg/wgs-84/)
and [epsg.io](https://epsg.io/4326) that indicate a code of `EPSG:4326`. `4326`
 is the SRID used for this shapefile.

We strongly recommend reading the [section about SRID](https://postgis.net/workshops/postgis-intro/loading_data.html#srid-26918-what-s-with-that) on the official Intro to PostGIS tutorial.
You'll see another example of a `.prj` that contains slightly different 
information -- in this case, a "PROJCS" value "NAD83 / UTM zone 18N". If you 
search only "NAD83" you might end up with a different EPSG code and not 26918.

So, if you have projection information _in addition to_ the reference system, 
it's probably a safer bet to confirm the SRID using both. With that said, 
finding out the SRID isn't always straightforward -- don't panic, and try to 
check with other GIS pros if you need to.
