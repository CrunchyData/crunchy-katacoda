# Geometry Constructing Functions

This scenario gives you an introduction to geometry constructing functions in PostGIS.

All the functions we have seen so far work with geometries "as they are" and returns

* analyses of the objects (`ST_Length(geometry)`, `ST_Area(geometry)`),
* serializations of the objects (`ST_AsText(geometry)`, `ST_AsGML(geometry)`),
* parts of the object (`ST_RingN(geometry,n)`) or
* true/false tests (`ST_Contains(geometry,geometry)`, `ST_Intersects(geometry,geometry)`).

"Geometry constructing functions" take geometries as inputs and output new shapes.

The database has already been started and the spatial data has already been loaded. This scenario will use data from New York City (NYC). If you want to dig in deeper on the data please go ahead and do [this scenario](TODO link to paul's scenario) first. Data from this scenario will be used in all the other exercises as well.

We have already logged you into the PostgreSQL command line but, if you get disconnected here are the details on the database we are connecting to:

1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: nyc

And with that, let's dig in.
