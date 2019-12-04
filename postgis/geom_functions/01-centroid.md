A common need when composing a spatial query is to replace a polygon feature with a point representation of the feature. For example, this is useful for spatial joins, because using `ST_Intersects(geometry,geometry)` on two polygon layers often results in double-counting: a polygon on a boundary will intersect an object on both sides. Using  "proxy points" for one layer of polygons ensures each will fall into only one of the other polygons.

* `ST_Centroid(geometry)` returns a point that is approximately on the center of mass of the input argument. This simple calculation is fast, but sometimes not desirable, because the returned point is not necessarily in the feature itself. If the input feature has a convexity (imagine the letter 'C') the returned centroid might not be in the interior of the feature.
* `ST_PointOnSurface(geometry)` returns a point that is *guaranteed* to be inside the input geometry.  This makes it more useful for computing "proxy points".

The picture below shows the difference between the two functions.
Note that the result of `ST_Centroid` does not lie inside the polygon.

![ST_Centroid, ST_PointOnSurface](geom_functions/assets/centroid.jpg)

We can check this using the `ST_Intersects` spatial relationship function.
The following query compares the locations of `ST_Centroid` and `ST_PointOnSurface`
for a concave polygon:

```
SELECT ST_Intersects(geom, ST_Centroid(geom)) AS centroid_inside,
ST_Intersects(geom, ST_PointOnSurface(geom)) AS pos_inside
FROM (VALUES ('POLYGON ((30 0, 30 10, 10 10, 10 40, 30 40, 30 50, 0 50, 0 0, 0 0, 30 0))'::geometry)) AS t(geom);
```{{execute}}
