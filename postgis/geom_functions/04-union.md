In the previous section we intersected geometries,
creating a new geometry that had linework from both the inputs.
The `ST_Union` function does the reverse;
it takes input geometries and removes common lines.

There are two forms of the ST_Union function:

* `ST_Union(geometry, geometry)`: A two-argument version that takes in two geometries and returns the merged union.
  For example, the two-circle example from the previous section looks like this when you replace the intersection with a union.

```{.sql}
SELECT ST_AsText(ST_Union(
  ST_Buffer('POINT(0 0)', 2),
  ST_Buffer('POINT(3 0)', 2)
));
```{{execute}}

![ST_Union](geom_functions/assets/union.jpg)

* `ST_Union([geometry])`: An aggregate version that takes in a set of geometries and returns the merged geometry for the entire group.
  The aggregate `ST_Union` can be used with the `GROUP BY` SQL clause to create carefully merged subsets of basic geometries.
  It is very powerful.

As an example of `ST_Union` aggregation,
consider our `nyc_census_blocks` table.
Census areas is carefully constructed so that larger areas can be built up from smaller ones.
Census tracts are formed by groups of blocks, and counties are formed by grouping tracts.
So, we can create a county map by merging blocks that fall within each county.

To carry out the merge, note that the unique key `blkid` actually embeds information about the higher level geographies. Here are the parts of the key for the Liberty Island block we used earlier:

```
360610001001001 = 36 061 000100 1 001

36     = State of New York
061    = New York County (Manhattan)
000100 = Census Tract
1      = Census Block Group
001    = Census Block
```

So, we can create a county map by merging all geometries that share the same first 5 digits of their `blkid`.
Be patient; this is computationally expensive and can take a minute or two.

```{.sql}
-- Create a nyc_census_counties table by merging census blocks
CREATE TABLE nyc_census_counties AS
SELECT
  ST_Union(geom)::Geometry(MultiPolygon,26918) AS geom,
  SubStr(blkid,1,5) AS countyid
FROM nyc_census_blocks
GROUP BY countyid;
```{{execute}}

![New York counties](geom_functions/assets/union_counties.png)

An area test can confirm that our union operation did not lose any geometry.
First, we calculate the area of each individual census block, and sum those areas grouping by census county id.

```
SELECT SubStr(blkid,1,5) AS countyid, Sum(ST_Area(geom)) AS area
FROM nyc_census_blocks
GROUP BY countyid ORDER BY countyid;
```{{execute}}

Then we calculate the area of each of our new county polygons from the county table:

```
SELECT countyid, ST_Area(geom) AS area
FROM nyc_census_counties ORDER BY countyid;
```{{execute}}

The answers are the same!
We have successfully used `ST_Union` to build an NYC county table from our census block data.
