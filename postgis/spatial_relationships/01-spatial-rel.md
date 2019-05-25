A powerful feature of PostGIS is the ability to compare spatial relationships between geometries.

This allow answering questions like “Which are the closest bike racks to a park?”
or “Where are the intersections of subway lines and streets?”
by comparing geometries representing the bike racks, streets, and subway lines.

PostGIS provides the full set of spatial relationship functions defined in the Open Geospatial Consortium/SQL-MM standard.
The functions allow testing both spatial (topological) relationships and relationship based on distance between geometries.

Most of the relationship functions accept two geometries as input, and return the value of the specified relationship as
a boolean value.  You can try this with the following query:

```
SELECT ST_Intersects('POINT(1 1)', 'LINESTRING(1 1, 2 2)');
```{{execute}}

Usually the boolean relationship functions are used in the ``WHERE`` clause of SQL queries (this is known as a *spatial filter*).
You will see examples of this using the NYC sample dataset later in this course.

They are also used in `JOIN .. ON` clauses to specify a *spatial join*.  This is covered in another course on this site.
