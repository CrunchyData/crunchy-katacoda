Geometry Input and Output
-------------------------

Within the database, geometries are stored on disk in a format only used by the PostGIS program. In order for external programs to insert and retrieve useful geometries, they need to be converted into a format that other applications can understand. Fortunately, PostGIS supports emitting and consuming geometries in a large number of formats:

-   Well-known text (WKT)
    -   ST\_GeomFromText(text, srid) returns `geometry`
    -   ST\_AsText(geometry) returns `text`
    -   ST\_AsEWKT(geometry) returns `text`
-   Well-known binary (WKB)
    -   ST\_GeomFromWKB(bytea) returns `geometry`
    -   ST\_AsBinary(geometry) returns `bytea`
    -   ST\_AsEWKB(geometry) returns `bytea`
-   Geographic Mark-up Language (GML)
    -   ST\_GeomFromGML(text) returns `geometry`
    -   ST\_AsGML(geometry) returns `text`
-   Keyhole Mark-up Language (KML)
    -   ST\_GeomFromKML(text) returns `geometry`
    -   ST\_AsKML(geometry) returns `text`
-   GeoJSON
    -   ST\_AsGeoJSON(geometry) returns `text`
-   Scalable Vector Graphics (SVG)
    -   ST\_AsSVG(geometry) returns `text`

The most common use of a constructor is to turn a text representation of a geometry into an internal representation:

``` {.sourceCode .sql}
SELECT ST_GeomFromText('POINT(583571 4506714)',26918);
```{{execute}}

Note that in addition to a text parameter with a geometry representation, we also have a numeric parameter providing the SRID of the geometry.

The following SQL query shows an example of WKB representation (the call to encode() is required to convert the binary output into an ASCII form for printing):

``` {.sourceCode .sql}
SELECT encode(
  ST_AsBinary(ST_GeometryFromText('LINESTRING(0 0,1 0)')), 
  'hex');
```{{execute}}

    01020000000200000000000000000000000000000000000000000000000000f03f0000000000000000

For the purposes of this class we will continue to use WKT to ensure you can read and understand the geometries we're viewing. However, most actual processes, such as viewing data in a GIS application, transferring data to a web service, or processing data remotely, WKB is the format of choice.

Since WKT and WKB were defined in the SFSQL specification, they do not handle 3- or 4-dimensional geometries. For these cases PostGIS has defined the Extended Well Known Text (EWKT) and Extended Well Known Binary (EWKB) formats. These provide the same formatting capabilities of WKT and WKB with the added dimensionality.

Here is an example of a 3D linestring in WKT:

``` {.sourceCode .sql}
SELECT ST_AsText(ST_GeometryFromText('LINESTRING(0 0 0,1 0 0,1 1 2)'));
```{{execute}}

    LINESTRING Z (0 0 0,1 0 0,1 1 2)

Note that the text representation changes! This is because the text input routine for PostGIS is liberal in what it consumes. It will consume

-   hex-encoded EWKB,
-   extended well-known text, and
-   ISO standard well-known text.

On the output side, the ST\_AsText function is conservative, and only emits ISO standard well-known text.

In addition to the ST\_GeometryFromText function, there are many other ways to create geometries from well-known text or similar formatted inputs:

``` {.sourceCode .sql}
-- Using ST_GeomFromText with the SRID parameter
SELECT ST_GeomFromText('POINT(2 2)',4326);

-- Using ST_GeomFromText without the SRID parameter
SELECT ST_SetSRID(ST_GeomFromText('POINT(2 2)'),4326);

-- Using a ST_Make* function
SELECT ST_SetSRID(ST_MakePoint(2, 2), 4326);

-- Using PostgreSQL casting syntax and ISO WKT
SELECT ST_SetSRID('POINT(2 2)'::geometry, 4326);

-- Using PostgreSQL casting syntax and extended WKT
SELECT 'SRID=4326;POINT(2 2)'::geometry;
```{{execute}}

In addition to emitters for the various forms (WKT, WKB, GML, KML, JSON, SVG), PostGIS also has consumers for four (WKT, WKB, GML, KML). Most applications use the WKT or WKB geometry creation functions, but the others work too. Here's an example that consumes GML and output JSON:

``` {.sourceCode .sql}
SELECT ST_AsGeoJSON(ST_GeomFromGML('<gml:Point><gml:coordinates>1,1</gml:coordinates></gml:Point>'));
```{{execute}}

![image](/geometries/assets/represent-07.png)

Casting from Text
-----------------

The WKT strings we've see so far have been of type 'text' and we have been converting them to type 'geometry' using PostGIS functions like ST\_GeomFromText().

PostgreSQL includes a short form syntax that allows data to be converted from one type to another, the casting syntax, oldata::newtype. So for example, this SQL converts a double into a text string.

``` {.sourceCode .sql}
SELECT 0.9::text;
```{{execute}}

Less trivially, this SQL converts a WKT string into a geometry:

``` {.sourceCode .sql}
SELECT 'POINT(0 0)'::geometry;
```{{execute}}

One thing to note about using casting to create geometries: unless you specify the SRID, you will get a geometry with an unknown SRID. You can specify the SRID using the "extended" well-known text form, which includes an SRID block at the front:

``` {.sourceCode .sql}
SELECT 'SRID=4326;POINT(0 0)'::geometry;
```{{execute}}

It's very common to use the casting notation when working with WKT, as well as geometry and geography columns (see geography).
