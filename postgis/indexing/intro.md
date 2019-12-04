# Introduction to Spatial Indexing in PostGIS
This scenario is going give you an introduction to Spatial Indexing in PostGIS. Spatial indexing makes queries that filter on coordinates run much faster. If you’re searching using a spatial function like `ST_Intersects()` or `ST_Within()` then creating a spatial index will improve speed immensely.
 
The database has already been started and the spatial data has already been loaded. This scenario will use data from New York City (NYC). Data from this scenario will be used in all the other exercises as well.

We have already logged you into the PostgreSQL command line but, if you get disconnected here are the details on the database we are connecting to:
1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: nyc

And with that, let's dig in. 

