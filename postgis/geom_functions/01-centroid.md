A common need when composing a spatial query is to replace a polygon feature with a point representation of the feature. This is useful for spatial joins, because using `ST_Intersects(geometry,geometry)` on two polygon layers often results in double-counting: a polygon on a boundary will intersect an object on both sides; replacing it with a point forces it to be on one side or the other, not both.

* `ST_Centroid(geometry)` returns a point that is approximately on the center of mass of the input argument. This simple calculation is very fast, but sometimes not desirable, because the returned point is not necessarily in the feature itself. If the input feature has a convexity (imagine the letter 'C') the returned centroid might not be in the interior of the feature.
* `ST_PointOnSurface(geometry)` returns a point that is *guaranteed* to be inside the input geometry.

![ST_Centroid, ST_PointOnSurface](geom_functions/assets/centroid.png)
