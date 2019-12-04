Index-Only Queries
------------------

Most of the commonly used functions in PostGIS
(`ST_Contains`,
`ST_Intersects`,
`ST_DWithin`, etc) include an index
filter automatically. But some functions (e.g.,
`ST_Relate`) do not include and index
filter.

To do a bounding-box search using the index (and no filtering), make use
of the `&&` operator. For geometries,
the `&&` operator means "bounding
boxes overlap or touch" in the same way that for number the
`=` operator means "values are the
same".

Let's compare an index-only query for the population of the 'West
Village' to a more exact query. Using `&&` our index-only query looks like the following:

```
SELECT Sum(popn_total) 
FROM nyc_neighborhoods neighborhoods
JOIN nyc_census_blocks blocks
ON neighborhoods.geom && blocks.geom
WHERE neighborhoods.name = 'West Village';
```{{execute}}

    49821

Now let's do the same query using the more exact
`ST_Intersects` function.

```
SELECT Sum(popn_total) 
FROM nyc_neighborhoods neighborhoods
JOIN nyc_census_blocks blocks
ON ST_Intersects(neighborhoods.geom, blocks.geom)
WHERE neighborhoods.name = 'West Village';
```{{execute}}

    26718

A much lower answer! The first query summed up every block that
intersected the neighborhood's bounding box; the second query only
summed up those blocks that intersected the neighborhood itself.