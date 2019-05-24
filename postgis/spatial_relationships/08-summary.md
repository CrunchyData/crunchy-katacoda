You have now learned about how PostGIS supports a full set of standard spatial and distance relationship functions.

Technically speaking, the spatial relationships are based on a mathematical model called the Dimensionally-Extended 9 Intersection Matrix,
details of which are available [here](https://en.wikipedia.org/wiki/DE-9IM).

The functions and their definitions are summarized below:

Spatial Relationship functions
------------------------------

* **ST_Contains(geometry A, geometry B)**: Returns true if and only if no points of B lie in the exterior of A, and at least one point of the interior of B lies in the interior of A.  The converse of **ST_Within**.

* **ST_Crosses(geometry A, geometry B)**: Returns true if the supplied geometries have some, but not all, interior points in common.

* **ST_Disjoint(geometry A , geometry B)**: Returns true if the geometries do not spatially intersect - i.e.
  if they do not share any points in common.  The inverse of **ST_Intersects**.

* **ST_Equals(geometry A, geometry B)**: Returns true if the geometries have the exact same shape. Directionality is not considered.

* **ST_Intersects(geometry A, geometry B)**: Returns true if the geometries “spatially intersect” - i.e. if they have at least one spatial point in common.  The inverse of **ST_Disjoint**.

* **ST_Overlaps(geometry A, geometry B)**: Returns true if the geometries share space, are of the same dimension, but are not completely contained by each other.

* **ST_Touches(geometry A, geometry B)**: Returns true if the geometries have at least one point in common, but their interiors do not intersect.

* **ST_Within(geometry A , geometry B)**: Returns true if the geometry A is completely inside geometry B.  The converse of **ST_Contains**.

Distance Relationship functions
-------------------------------

* **ST_Distance(geometry A, geometry B)**: Returns the 2-dimensional cartesian minimum distance between two geometries, in the units of the spatial reference system.

* **ST_DWithin(geometry A, geometry B, radius)**: Returns true if two geometries are within the specified distance (radius) of one another.
