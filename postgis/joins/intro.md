# Projection

This scenario is going to give you an introduction to spatial joins in PostGIS. "Joins" are a database technique to match rows in two tables. Usually joins use an identifying key, matching numbers or strings between tables. Spatial joins use a spatial condition to match rows: rows with geometries that intersect, or geometries within a certain radius, are matched up.
 
The database has already been started and the spatial data has already been loaded. This scenario will use data from New York City (NYC). Data from this scenario is used in all the other exercises as well.

We have already logged you into the PostgreSQL command line but, if you get disconnected here are the details on the database we are connecting to:

* Username: groot
* Password: password
* A database named: nyc

