You have now learned about how PostGIS supports a set of powerful functions
for constructing new geometries of various kinds.

The geometry constructing functions are summarized below:

* `ST_Centroid(geometry)`: Returns a point that is on the center of mass of the input geometry

* `ST_PointOnSurface(geometry)`: Returns a point that is *guaranteed* to be inside the input geometry

* `ST_Buffer(geometry, distance)`: For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper.

* `ST_Intersection(geometry A, geometry B)`: Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.

* `ST_Union()`: Returns a geometry that represents the point set union of the Geometries.
