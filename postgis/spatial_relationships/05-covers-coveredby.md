PostGIS provides another pair of functions for testing containment, **ST_Covers** and **ST_CoveredBy**.

These functions are not part of the SQL/MM standard, but they
address a subtlety of **ST_Contains** and **ST_Within** which can occasionally
cause problems.  The standard definition of **ST_Contains** has the quirk that
polygons do not contain Linestrings which lie along their edge
(in their boundary).

```
SELECT ST_Contains('POLYGON ((0 1, 1 1, 1 0, 0 0, 0 1))', 'LINESTRING (0 0, 1 0)');
```{{execute}}

```
  f
```

**ST_Covers(geometry A, geometry B)** is defined so that this anomaly does not occur,
which generally corresponds more closely to what you would expect.

```
SELECT ST_Covers('POLYGON ((0 1, 1 1, 1 0, 0 0, 0 1))', 'LINESTRING (0 0, 1 0)');
```{{execute}}

```
  t
```

**ST_CoveredBy(geometry A, geometry B)** has the opposite meaning to *ST_Covers**, so that:

```
  ST_Covers(A,B) = ST_CoveredBy(B, A)
```
