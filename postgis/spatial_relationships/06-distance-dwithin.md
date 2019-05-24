A common GIS question is "find all the stuff within distance
X of this other stuff".

The **ST_Distance(geometry A, geometry B)** calculates the *shortest*
distance between two geometries and returns it as a float. This is
useful for actually reporting back the distance between objects.

```
SELECT ST_Distance(
  ST_GeometryFromText('POINT(0 5)'),
  ST_GeometryFromText('LINESTRING(-2 2, 2 2)'));
```{{execute}}

```
    3
```
> NOTE: The distance value returned is in the units of the spatial reference
system of the input geometries

ST_DWithin
----------

For testing whether two objects are within a distance of one another,
the **ST_DWithin** function provides an index-accelerated true/false test.
This is useful for questions like "how many trees are within a 500 meter
buffer of the road?". You don't have to calculate an actual buffer, you
just have to test the distance relationship.

![](spatial_relationships/assets/st_dwithin.png)

Using the Broad Street subway station again, we can find the streets
nearby (within 10 meters of) the subway stop:

```
SELECT name
FROM nyc_streets
WHERE ST_DWithin(
        geom,
        ST_GeomFromText('POINT(583571 4506714)',26918),
        10
      );
```{{execute}}

```
    name
--------------
Wall St
Broad St
Nassau St
```

And we can verify the answer on a map. The Broad St station is actually
at the intersection of Wall, Broad and Nassau Streets.

![Broad Street](spatial_relationships/assets/broad_st.jpg)
