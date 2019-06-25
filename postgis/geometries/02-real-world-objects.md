Representing Real World Objects
-------------------------------

The Simple Features for SQL (SFSQL) specification, the original guiding standard for PostGIS development, defines how a real world object is represented. By taking a continuous shape and digitizing it at a fixed resolution we achieve a passable representation of the object. SFSQL only handled 2-dimensional representations. PostGIS has extended that to include 3- and 4-dimensional representations; more recently the SQL-Multimedia Part 3 (SQL/MM) specification has officially defined their own representation.

Our example table contains a mixture of different geometry types. We can collect general information about each object using functions that read the geometry metadata.

-   ST\_GeometryType(geometry) returns the type of the geometry
-   ST\_NDims(geometry) returns the number of dimensions of the geometry
-   ST\_SRID(geometry) returns the spatial reference identifier number of the geometry

```postgresql
SELECT name, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
  FROM geometries;
```{{execute}}

```    
name       |    st_geometrytype    | st_ndims | st_srid 

-----------------+-----------------------+----------+--------- 
Point | ST\_Point | 2 | 0  
Polygon | ST\_Polygon | 2 | 0 
PolygonWithHole | ST\_Polygon | 2 | 0 
Collection | ST\_GeometryCollection | 2 | 0 
Linestring | ST\_LineString | 2 | 0
```

### Points

![image](geometries/assets/points.png)


A spatial **point** represents a single location on the Earth. This point is represented by a single coordinate (including either 2-, 3- or 4-dimensions). Points are used to represent objects when the exact details, such as shape and size, are not important at the target scale. For example, cities on a map of the world can be described as points, while a map of a single state might represent cities as polygons.

```postgresql
SELECT ST_AsText(geom) 
  FROM geometries
  WHERE name = 'Point';
```{{execute}}

    POINT(0 0)

Some of the specific spatial functions for working with points are:

-   ST\_X(geometry) returns the X ordinate
-   ST\_Y(geometry) returns the Y ordinate

So, we can read the ordinates from a point like this:

```postgresql
SELECT ST_X(geom), ST_Y(geom)
  FROM geometries
  WHERE name = 'Point';
```{{execute}}

The New York City subway stations (`nyc_subway_stations`) table is a data set represented as points. The following SQL query will return the geometry associated with one point (in the ST\_AsText column).

```postgresql
SELECT name, ST_AsText(geom)
  FROM nyc_subway_stations
  LIMIT 1;
```{{execute}}

### Linestrings

![image](geometries/assets//lines.png)

A **linestring** is a path between locations. It takes the form of an ordered series of two or more points. Roads and rivers are typically represented as linestrings. A linestring is said to be **closed** if it starts and ends on the same point. It is said to be **simple** if it does not cross or touch itself (except at its endpoints if it is closed). A linestring can be both **closed** and **simple**.

The street network for New York (`nyc_streets`) was loaded earlier in the workshop. This dataset contains details such as name, and type. A single real world street may consist of many linestrings, each representing a segment of road with different attributes.

The following SQL query will return the geometry associated with one linestring (in the ST\_AsText column).

```postgresql
SELECT ST_AsText(geom) 
  FROM geometries
  WHERE name = 'Linestring';
```{{execute}}

    LINESTRING(0 0, 1 1, 2 1, 2 2)

Some of the specific spatial functions for working with linestrings are:

-   ST\_Length(geometry) returns the length of the linestring
-   ST\_StartPoint(geometry) returns the first coordinate as a point
-   ST\_EndPoint(geometry) returns the last coordinate as a point
-   ST\_NPoints(geometry) returns the number of coordinates in the linestring

So, the length of our linestring is:

```postgresql
SELECT ST_Length(geom) 
  FROM geometries
  WHERE name = 'Linestring';
```{{execute}}

    3.41421356237309

### Polygons

![image](geometries/assets/polygons.png)

A polygon is a representation of an area. The outer boundary of the polygon is represented by a ring. This ring is a linestring that is both closed and simple as defined above. Holes within the polygon are also represented by rings.

Polygons are used to represent objects whose size and shape are important. City limits, parks, building footprints or bodies of water are all commonly represented as polygons when the scale is sufficiently high to see their area. Roads and rivers can sometimes be represented as polygons.

The following SQL query will return the geometry associated with one linestring (in the ST\_AsText column).

```postgresql
SELECT ST_AsText(geom) 
  FROM geometries
  WHERE name LIKE 'Polygon%';
```{{execute}}

> **note**
>
> Rather than using an `=` sign in our `WHERE` clause, we are using the `LIKE` operator to carry out a string matching operation. **You may be used to the `*` symbol as a "glob" for pattern matching, but in SQL the `%` symbol is used**, along with the `LIKE` operator to tell the system to do globbing.

    POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))
    POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))

The first polygon has only one ring. The second one has an interior "hole". Most graphics systems include the concept of a "polygon", but GIS systems are relatively unique in allowing polygons to explicitly have holes.

![image](geometries/assets/polygons2.png)

Some of the specific spatial functions for working with polygons are:

-   ST\_Area(geometry) returns the area of the polygons
-   ST\_NRings(geometry) returns the number of rings (usually 1, more of there are holes)
-   ST\_ExteriorRing(geometry) returns the outer ring as a linestring
-   ST\_InteriorRingN(geometry,n) returns a specified interior ring as a linestring
-   ST\_Perimeter(geometry) returns the length of all the rings

We can calculate the area of our polygons using the area function:

```postgresql
SELECT name, ST_Area(geom) 
  FROM geometries
  WHERE name LIKE 'Polygon%';
```{{execute}}

    Polygon            1
    PolygonWithHole    99

Note that the polygon with a hole has an area that is the area of the outer shell (a 10x10 square) minus the area of the hole (a 1x1 square).

### Collections

There are four collection types, which group multiple simple geometries into sets.

-   **MultiPoint**, a collection of points
-   **MultiLineString**, a collection of linestrings
-   **MultiPolygon**, a collection of polygons
-   **GeometryCollection**, a heterogeneous collection of any geometry (including other collections)

Collections are another concept that shows up in GIS software more than in generic graphics software. They are useful for directly modeling real world objects as spatial objects. For example, how to model a lot that is split by a right-of-way? As a **MultiPolygon**, with a part on either side of the right-of-way.

![image](geometries/assets/collection2.png)

Our example collection contains a polygon and a point:

```postgresql
SELECT name, ST_AsText(geom) 
  FROM geometries
  WHERE name = 'Collection';
```{{execute}}

    GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))

![image](geometries/assets/collection.png)

Some of the specific spatial functions for working with collections are:

-   ST\_NumGeometries(geometry) returns the number of parts in the collection
-   ST\_GeometryN(geometry,n) returns the specified part
-   ST\_Area(geometry) returns the total area of all polygonal parts
-   ST\_Length(geometry) returns the total length of all linear parts
