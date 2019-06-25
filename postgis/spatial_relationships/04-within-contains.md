**ST_Within** and **ST_Contains** is a pair of functions
which have related but opposite meanings.

**ST_Within(geometry A , geometry B)** returns TRUE if the first geometry
is completely within the second geometry,
and they have at least one interior point in common.

![](spatial_relationships/assets/st_within.png)

**ST_Contains(geometry A, geometry B)** returns TRUE if the first geometry
completely contains the second geometry,
and they have at least one interior point in common.

**ST_Contains** tests for the opposite relationship of **ST_Within**.
Symbolically, this means

```
  ST_Contains(A,B) = ST_Within(B, A)
```
