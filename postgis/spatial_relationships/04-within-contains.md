**ST_Within** and **ST_Contains** are a pair of functions with opposite meanings.

ST_Within
---------

**ST_Within(geometry A , geometry B)** returns TRUE if the first geometry
is completely within the second geometry.

![](spatial_relationships/assets/st_within.png)

ST_Contains
-----------

**ST_Contains(geometry A, geometry B)** returns TRUE if the second geometry
is completely contained by the first geometry.
**ST_Contains** tests for the exact opposite result of **ST_Within**.
