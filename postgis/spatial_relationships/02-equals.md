**ST_Equals(geometry A, geometry B)** tests the spatial equality of two geometries.
It returns TRUE if two geometries of the same type have identical shapes.
This is generally only the case if they have identical x,y coordinate values.

![ST_Equals](spatial_relationships/assets/st_equals.png)

For example, let’s use a point geometry from the `nyc_subway_stations` table.
We’ll query the feature for the Broad St station,
and display it using an exact data representation (known as WKB) and in a more readable text format (called WKT):

```
SELECT name, geom, ST_AsText(geom)
FROM nyc_subway_stations
WHERE name = 'Broad St';
```{{execute}}

```
   name   |                      geom                          |      st_astext
----------+----------------------------------------------------+-----------------------
 Broad St | 0101000020266900000EEBD4CF27CF2141BC17D69516315141 | POINT(583571 4506714)
```

The geometry value can be used with a `ST_Equals` test to retrieve the original record:

```
SELECT name
FROM nyc_subway_stations
WHERE ST_Equals(geom, '0101000020266900000EEBD4CF27CF2141BC17D69516315141');
```{{execute}}

```
Broad St
```

> NOTE: The WKB data format of the point is not human readable (`0101000020266900000EEBD4CF27CF2141BC17D69516315141`) but it is an exact representation of the coordinate values. For a test like equality, using the exact value is necessary.
