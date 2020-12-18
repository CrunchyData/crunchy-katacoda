When you load a spatial dataset into PostGIS, you'll either specify what 
SRS to use, or it may be detected for you, depending on 
the import tool you use as well as the format the data came in. Generally 
you'll use the spatial reference identifier (SRID) to assign the reference 
system. Each SRS in `spatial_ref_sys` has a unique SRID.

You may have seen that `spatial_ref_sys` also has an `auth_srid` column. `srid`
 is an SRS's unique identifier in PostGIS, whereas `auth_srid` is the ID 
 given by the Authority stored in the `auth_name` column. EPSG is one such 
 authority -- we'll get to that in a second. The vast majority of SRS's that 
 come with `spatial_ref_sys` by default will have the same `srid` and `auth_srid`. 

### How do we know what SRID to use?

An organization called European Petroleum Survey Group (EPSG) put together a [database 
of coordinate systems](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
 and gave each system a unique number, known as an EPSG 
code. Most GIS software (PostGIS, QGIS, ArcGIS, etc) will understand the EPSG 
code to define the coordinate system. 

You might be able to confirm the SRID by examining the contents of your data 
file/s: for example, the `.prj` file if you have a shapefile. Let's give it a 
try.

```
\q
```{{execute}}
```
cat /data/tpa/Parking_Garages_and_Lots.prj
```{{execute}}

We've logged out of `psql` and used the `cat` command-line utility to check 
Parking_Garages_and_Lots.prj's contents. You should see a string that starts 
like this:

`GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984"...`

Let's do a search on the internet for "WGS 1984 EPSG" -- click the **Browser** 
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
