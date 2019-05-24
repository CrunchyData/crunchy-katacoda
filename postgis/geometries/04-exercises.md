## Some Additional Exercises
To help you do the following exercises, we have included a list of links to the documentation for some relavant functions on the bottom of this page.

Here is a reminder of the tables we have available:

-   `nyc_census_blocks`
    -   blkid, popn\_total, boroname, geom
-   `nyc_streets`
    -   name, type, geom
-   `nyc_subway_stations`
    -   name, geom
-   `nyc_neighborhoods`
    -   name, boroname, geom
    
Exercises
---------

-   **"What is the area of the 'West Village' neighborhood?"**

    ```postgresql
    SELECT ST_Area(geom)
      FROM nyc_neighborhoods
      WHERE name = 'West Village';
    ```{{execute}}

        1044614.5296486

> **note**
>
> The area is given in square meters. To get an area in hectares, divide by 10000. To get an area in acres, divide by 4047.

-   **"What is the area of Manhattan in acres?"** (Hint: both `nyc_census_blocks` and `nyc_neighborhoods` have a `boroname` in them.)

    ``` postgresql
    SELECT Sum(ST_Area(geom)) / 4047
      FROM nyc_neighborhoods
      WHERE boroname = 'Manhattan';
    ``` {{execute}}

        13965.3201224118

    or...

    ````postgresql
    SELECT Sum(ST_Area(geom)) / 4047
      FROM nyc_census_blocks
      WHERE boroname = 'Manhattan';
    ```{{execute}}

        14601.3987215548

-   **"How many census blocks in New York City have a hole in them?"**

    ```postgresql
    SELECT Count(*) 
      FROM nyc_census_blocks
      WHERE ST_NumInteriorRings(ST_GeometryN(geom,1)) > 0;
    ```{{execute}}

> **note**
>
> The ST\_NRings() functions might be tempting, but it also counts the exterior rings of multi-polygons as well as interior rings. In order to run ST\_NumInteriorRings() we need to convert the MultiPolygon geometries of the blocks into simple polygons, so we extract the first polygon from each collection using ST\_GeometryN(). Yuck!

    43

-   **"What is the total length of streets (in kilometers) in New York City?"** (Hint: The units of measurement of the spatial data are meters, there are 1000 meters in a kilometer.)

    ```postgresql
    SELECT Sum(ST_Length(geom)) / 1000
      FROM nyc_streets;
    ```{{execute}}

        10418.9047172

-   **"How long is 'Columbus Cir' (Columbus Circle)?**

    ```postgresql
    SELECT ST_Length(geom)
      FROM nyc_streets
      WHERE name = 'Columbus Cir';
    ```{{execute}}

        308.34199

-   **"What is the JSON representation of the boundary of the 'West Village'?"**

    ```postgresql
    SELECT ST_AsGeoJSON(geom)
      FROM nyc_neighborhoods
      WHERE name = 'West Village';
    ```{{execute}}

        {"type":"MultiPolygon","coordinates":
         [[[[583263.2776595836,4509242.6260239873],
            [583276.81990686338,4509378.825446927], ...
            [583263.2776595836,4509242.6260239873]]]]}

    The geometry type is "MultiPolygon", interesting!

-   **"How many polygons are in the 'West Village' multipolygon?"**

    ```postgresql
    SELECT ST_NumGeometries(geom)
      FROM nyc_neighborhoods
      WHERE name = 'West Village';
    ```{{execute}}

        1

> **note**
>
> It is not uncommon to find single-element MultiPolygons in spatial tables. Using MultiPolygons allows a table with only one geometry type to store both single- and multi-geometries without using mixed types.

-   **"What is the length of streets in New York City, summarized by type?"**

    ```postgresql
    SELECT type, Sum(ST_Length(geom)) AS length
    FROM nyc_streets
    GROUP BY type
    ORDER BY length DESC;
    ```{{execute}}

```
        type                       |      length      

     --------------------------------------------------+------------------ 
     residential | 8629870.33786606  
     motorway | 403622.478126363 
     tertiary | 360394.879051303 
     motorway\_link | 294261.419479668 
     secondary | 276264.303897926 
     unclassified | 166936.371604458 
     primary | 135034.233017947 
     footway | 71798.4878378096 
     service | 28337.635038596 
     trunk | 20353.5819826076 
     cycleway | 8863.75144825929 
     pedestrian | 4867.05032825026 
     construction | 4803.08162103562 
     residential; motorway\_link | 3661.57506293745 
     trunk\_link | 3202.18981240201 
     primary\_link | 2492.57457083536 
     living\_street | 1894.63905457332 
     primary; residential; motorway\_link; residential | 1367.76576941335 
     undefined | 380.53861910346 
     steps | 282.745221342127 
     motorway\_link; residential | 215.07778911517\
```

    
> **note**
>
> The `ORDER BY length DESC` clause sorts the result by length in descending order. The result is that most prevalent types are first in the list.
    
Those are all the exercises we came up with - feel free to play around with the data some more. 

### Function List

[ST\_Area](http://postgis.net/docs/ST_Area.html): Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.

[ST\_AsText](http://postgis.net/docs/ST_AsText.html): Returns the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.

[ST\_AsBinary](http://postgis.net/docs/ST_AsBinary.html): Returns the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.

[ST\_EndPoint](http://postgis.net/docs/ST_EndPoint.html): Returns the last point of a LINESTRING geometry as a POINT.

[ST\_AsEWKB](http://postgis.net/docs/ST_AsEWKB.html): Returns the Well-Known Binary (WKB) representation of the geometry with SRID meta data.

[ST\_AsEWKT](http://postgis.net/docs/ST_AsEWKT.html): Returns the Well-Known Text (WKT) representation of the geometry with SRID meta data.

[ST\_AsGeoJSON](http://postgis.net/docs/ST_AsGeoJSON.html): Returns the geometry as a GeoJSON element.

[ST\_AsGML](http://postgis.net/docs/ST_AsGML.html): Returns the geometry as a GML version 2 or 3 element.

[ST\_AsKML](http://postgis.net/docs/ST_AsKML.html): Returns the geometry as a KML element. Several variants. Default version=2, default precision=15.

[ST\_AsSVG](http://postgis.net/docs/ST_AsSVG.html): Returns a Geometry in SVG path data given a geometry or geography object.

[ST\_ExteriorRing](http://postgis.net/docs/ST_ExteriorRing.html): Returns a line string representing the exterior ring of the POLYGON geometry. Return NULL if the geometry is not a polygon. Will not work with MULTIPOLYGON

[ST\_GeometryN](http://postgis.net/docs/ST_GeometryN.html): Returns the 1-based Nth geometry if the geometry is a GEOMETRYCOLLECTION, MULTIPOINT, MULTILINESTRING, MULTICURVE or MULTIPOLYGON. Otherwise, return NULL.

[ST\_GeomFromGML](http://postgis.net/docs/ST_GeomFromGML.html): Takes as input GML representation of geometry and outputs a PostGIS geometry object.

[ST\_GeomFromKML](http://postgis.net/docs/ST_GeomFromKML.html): Takes as input KML representation of geometry and outputs a PostGIS geometry object

[ST\_GeomFromText](http://postgis.net/docs/ST_GeomFromText.html): Returns a specified ST\_Geometry value from Well-Known Text representation (WKT).

[ST\_GeomFromWKB](http://postgis.net/docs/ST_GeomFromWKB.html): Creates a geometry instance from a Well-Known Binary geometry representation (WKB) and optional SRID.

[ST\_GeometryType](http://postgis.net/docs/ST_GeometryType.html): Returns the geometry type of the ST\_Geometry value.

[ST\_InteriorRingN](http://postgis.net/docs/ST_InteriorRingN.html): Returns the Nth interior linestring ring of the polygon geometry. Return NULL if the geometry is not a polygon or the given N is out of range.

[ST\_Length](http://postgis.net/docs/ST_Length.html): Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)

[ST\_NDims](http://postgis.net/docs/ST_NDims.html): Returns coordinate dimension of the geometry as a small int. Values are: 2,3 or 4.

[ST\_NPoints](http://postgis.net/docs/ST_NPoints.html): Returns the number of points (vertexes) in a geometry.

[ST\_NRings](http://postgis.net/docs/ST_NRings.html): If the geometry is a polygon or multi-polygon returns the number of rings.

[ST\_NumGeometries](http://postgis.net/docs/ST_NumGeometries.html): If geometry is a GEOMETRYCOLLECTION (or MULTI\*) returns the number of geometries, otherwise return NULL.

[ST\_Perimeter](http://postgis.net/docs/ST_Perimeter.html): Returns the length measurement of the boundary of an ST\_Surface or ST\_MultiSurface value. (Polygon, Multipolygon)

[ST\_SRID](http://postgis.net/docs/ST_SRID.html): Returns the spatial reference identifier for the ST\_Geometry as defined in spatial\_ref\_sys table.

[ST\_StartPoint](http://postgis.net/docs/ST_StartPoint.html): Returns the first point of a LINESTRING geometry as a POINT.

[ST\_X](http://postgis.net/docs/ST_X.html): Returns the X coordinate of the point, or NULL if not available. Input must be a point.

[ST\_Y](http://postgis.net/docs/ST_Y.html): Returns the Y coordinate of the point, or NULL if not available. Input must be a point.