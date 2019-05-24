# ST_Equals

ST_Equals(geometry A, geometry B) tests the spatial equality of two geometries.

![ST_Equals](spatial_relationships/assets/st_equals.png)

ST_Equals returns TRUE if two geometries of the same type have identical x,y coordinate values, i.e. if the second shape is equal (identical) to the first shape.

First, let’s retrieve a representation of a point from our nyc_subway_stations table. We’ll take just the entry for ‘Broad St’.

```
SELECT name, geom, ST_AsText(geom)
FROM nyc_subway_stations
WHERE name = 'Broad St';
```{{execute}}

Then, plug the geometry representation back into an ST_Equals test:

```
SELECT name
FROM nyc_subway_stations
WHERE ST_Equals(geom, '0101000020266900000EEBD4CF27CF2141BC17D69516315141');
```{{execute}}

> NOTE: The representation of the point was not very human readable(`0101000020266900000EEBD4CF27CF2141BC17D69516315141`) but it was an exact representation of the coordinate values. For a test like equality, using the exact coordinates is necessary.
