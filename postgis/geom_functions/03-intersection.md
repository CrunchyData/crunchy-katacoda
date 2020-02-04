Another classic GIS operation – the “overlay” – creates a new coverage by calculating the intersection of two superimposed polygons. The resultant has the property that any polygon in either of the parents can be built by merging polygons in the resultant.

The `ST_Intersection(geometry A, geometry B)` function returns the spatial area (or line, or point) that both arguments have in common. If the arguments are disjoint, the function returns an empty geometry.

For example, the following query finds the area of intersection of circles around
two points as follows (using `ST_Buffer` to compute the circles):

```{.sql}
SELECT ST_AsText(ST_Intersection(
  ST_Buffer('POINT(0 0)', 2),
  ST_Buffer('POINT(3 0)', 2)
));
```{{execute}}

![ST_Intersection](geom_functions/assets/intersection.jpg)
