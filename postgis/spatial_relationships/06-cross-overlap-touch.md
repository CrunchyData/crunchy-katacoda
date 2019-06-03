
**ST_Crosses**, **ST_Overlaps**, and **ST_Touches** are less commonly-used functions
which test specific aspects of spatial relationship between geometries.

**ST_Crosses(geometry A, geometry B)** tests if the intersection
results in a geometry whose dimension is one less than the maximum
dimension of the two source geometries and the intersection set is
interior to both source geometries.
It applies only to Point/Polygon, Point/Linestring, Linestring/Linestring,
and Linestring/Polygon comparisons.

![](spatial_relationships/assets/st_crosses.png)

For example, this tests that a line crosses a polygon:
```
SELECT ST_Crosses('POLYGON ((100 100, 100 200, 200 200, 200 100, 100 100))',
'LINESTRING (50 150, 150 150)');
```{{execute}}

```
t
```

**ST_Overlaps(geometry A, geometry B)** compares two geometries of the same
dimension and returns true if their intersection set results in a
geometry different from both, but having the same dimension.

![](spatial_relationships/assets/st_overlaps.png)


**ST_Touches(geometry A, geometry B)** tests if either of the
geometries' boundaries intersect, or if only one of the geometry's
interiors intersects the other's boundary.

![](spatial_relationships/assets/st_touches.png)
