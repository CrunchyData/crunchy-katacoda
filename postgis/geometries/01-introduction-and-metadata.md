Introduction
------------

Before we start playing with our data lets have a look at some simpler examples. Go ahead and execute the following SQL statement in 
the console.

```postgresql
CREATE TABLE geometries (name varchar, geom geometry);

INSERT INTO geometries VALUES 
  ('Point', 'POINT(0 0)'),
  ('Linestring', 'LINESTRING(0 0, 1 1, 2 1, 2 2)'),
  ('Polygon', 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
  ('PolygonWithHole', 'POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
  ('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');

SELECT name, ST_AsText(geom) FROM geometries;
```{{execute}}

The bottom part of the image shows what you should see  

![image](geometries/assets/start01.png)

The above example CREATEs a table (**geometries**) then INSERTs five geometries: a point, a line, a polygon, a polygon with a hole, and a collection. Finally, the inserted rows are SELECTed and displayed in the Output pane.

Metadata Tables
---------------

In conformance with the Simple Features for SQL (SFSQL) specification, PostGIS provides two tables to track and report on the geometry types available in a given database.

-   The first table, `spatial_ref_sys`, defines all the spatial reference systems known to the database and will be described in greater detail later.
-   The second table (actually, a view), `geometry_columns`, provides a listing of all "features" (defined as an object with geometric attributes), and the basic details of those features.

![image](geometries/assets/table01.png)

Let's have a look at the `geometry_columns` table in our database. 

```postgresql
SELECT * FROM geometry_columns;
```{{execute}}

Again this screenshot shows you the output of the command above in a GUI. 

![image](geometries/assets/start08.png)

-   `f_table_catalog`, `f_table_schema`, and `f_table_name` provide the fully qualified name of the feature table containing a given geometry. Because PostgreSQL doesn't make use of catalogs, `f_table_catalog` will tend to be empty.
-   `f_geometry_column` is the name of the column that geometry containing column -- for feature tables with multiple geometry columns, there will be one record for each.
-   `coord_dimension` and `srid` define the the dimension of the geometry (2-, 3- or 4-dimensional) and the Spatial Reference system identifier that refers to the `spatial_ref_sys` table respectively.
-   The `type` column defines the type of geometry as described below; we've seen Point and Linestring types so far.

By querying this table, GIS clients and libraries can determine what to expect when retrieving data and can perform any necessary projection, processing or rendering without needing to inspect each geometry.

> **note**
>
> Do some or all of your `nyc` tables not have an `srid` of 26918? It's easy to fix by updating the table:
>
> ```postgresql
> SELECT UpdateGeometrySRID('nyc_neighborhoods','geom',26918);
> ```{{execute}}