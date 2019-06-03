The spatial relationship functions in the previous sections
are special cases of the more general function **ST_Relate**.
It determines the full topological relationship between two geometries.
The relationship is expressed as a textual code called the
Dimensionally-Extended 9 Intersection Model (DE-9IM for short).
The code provides the dimension of the intersections of
the interior, bounday and exterior of each input geometry.
Since there are nine combinations of these, the code has
nine symbols, each having the value of the dimension of
intersection (0, 1 or 2) or F if there is no intersection.

For example, the intersection of a line crossing a polygon has the
code `1020F1102`:

```
SELECT ST_Relate('POLYGON ((100 100, 100 200, 200 200, 200 100, 100 100))',
'LINESTRING (50 150, 150 150)');
```{{execute}}

```
1020F1102
```

Specific spatial relationships are determined by comparing the DE-9IM code to a "pattern mask" specifying the relationship desired.
In addition to the DE-9IM symbols masks can contain
`T`, indicating intersection of any dimension, and `*`, indicating
a wildcard or "don't care" value.
For example, the pattern mask for 'Crosses' for the Polygon/Line case is `T*****T**`, and it can be confirmed that the above example has this
relationship:

```
SELECT ST_Relate('POLYGON ((100 100, 100 200, 200 200, 200 100, 100 100))',
'LINESTRING (50 150, 150 150)',
'T*****T**' );
```{{execute}}

```
t
```

For most uses it is more convenient to use the named relationship functions.
But there are a few situations where there is no function providing the
relationship required.
For example, the GIS structure known as a polygonal coverage
is a collection of polygons in which no polygons have interiors
which intersect.  This is expressed by the matrix pattern 'F******'.
There is no named spatial relationship function testing
for this condition, so it must be tested using ST_Relate.

Here are two polygons whose interiors intersect, and thus do not form
a coverage:

```
SELECT ST_Relate('POLYGON ((100 100, 100 200, 200 200, 200 100, 100 100))',
'POLYGON ((250 250, 250 150, 150 150, 150 250, 250 250))',
'F******' );
```{{execute}}

```
f
```

Here are two polygons which form a valid polygonal coverage:

```
SELECT ST_Relate('POLYGON ((100 100, 100 200, 200 200, 200 100, 100 100))',
'POLYGON ((300 100, 200 100, 200 200, 300 200, 300 100))',
'F******' );
```{{execute}}

```
t
```
