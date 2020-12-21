Spatial data allows you to model and position things, typically on the Earth's 
surface. But a value like "POINT(-103.771555 44.967244)" is practically 
meaningless without a **spatial reference system** (SRS). (You may also come across the 
term "coordinate system" used interchangeably in GIS.)
 
A spatial reference system is a framework for understanding a set of spatial 
data. It provides information such as units of measurement (e.g. degrees, 
meters, feet); whether the data represents a location on the Earth represented as a 
sphere _or_  projected out on a flat surface, like a map; and, if it's on a 
projection, how the "flattening" is done. So, as you may already know or have 
guessed, a spatial value could be valid across different SRS's, but end up 
meaning entirely different things in each case. 

## Spatial reference systems and PostGIS

PostGIS comes with a list of spatial reference systems -- you can take a 
look at it by querying the `spatial_ref_sys` table. First, we'll log in to Postgres 
as user `groot`, toggle on extended display in the `psql` shell, then execute 
a SELECT query to return a single record (`srid = 4326`).

```
psql -U groot -h localhost workshop
```{{execute}}
```
\x

SELECT * FROM spatial_ref_sys WHERE srid = 26918;
```{{execute}}

In addition to having a frame of reference for a given set of spatial data, 
we also need to assign an SRS to ensure that different 
datasets can "work" together. You may be using various reference systems across 
your database but your functions and queries will still work because PostGIS 
understands how to process your data. 
