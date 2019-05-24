ST_Intersects
-------------

**ST_Intersects(geometry A, geometry B)** returns t (TRUE) if the two
shapes have any space in common, i.e., if their boundaries or interiors
intersect.

![](spatial_relationships/assets/st_intersects.png)

Let's take our Broad Street subway station and determine its
neighborhood using the **ST_Intersects** function:

```
SELECT name, ST_AsText(geom)
FROM nyc_subway_stations
WHERE name = 'Broad St';
```{{execute}}

```
    POINT(583571 4506714)
```

```
SELECT name, boroname
FROM nyc_neighborhoods
WHERE ST_Intersects(geom, ST_GeomFromText('POINT(583571 4506714)',26918));
```{{execute}}

```
       name        | boroname
-------------------+-----------
Financial District | Manhattan
```

ST_Disjoint
-----------

The opposite of **ST_Intersects** is **ST_Disjoint(geometry A , geometry B)**.
If two geometries are disjoint, they do not intersect, and vice-versa.
In fact, it is often more efficient to test "not intersects" than to
test "disjoint" because the intersects tests can be spatially indexed,
while the disjoint test cannot.

![](spatial_relationships/assets/st_disjoint.png)
