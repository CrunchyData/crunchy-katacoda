ST_Crosses
----------

For multipoint/polygon, multipoint/linestring, linestring/linestring,
linestring/polygon, and linestring/multipolygon comparisons,
**ST_Crosses(geometry A, geometry B)** returns t (TRUE) if the intersection
results in a geometry whose dimension is one less than the maximum
dimension of the two source geometries and the intersection set is
interior to both source geometries.

![](spatial_relationships/assets/st_crosses.png)

ST_Overlaps
-------------

**ST_Overlaps(geometry A, geometry B)** compares two geometries of the same
dimension and returns TRUE if their intersection set results in a
geometry different from both but of the same dimension.

![](spatial_relationships/assets/st_overlaps.png)

ST_Touches
-----------

**ST_Touches(geometry A, geometry B)** returns TRUE if either of the
geometries' boundaries intersect or if only one of the geometry's
interiors intersects the other's boundary.

![](spatial_relationships/assets/st_touches.png)
