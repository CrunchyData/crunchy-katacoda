More Spatial Joins
==================

In the [geometry functions](TODO) we saw the **ST_Centroid(geometry)** and
**ST_Union(\[geometry\])** functions, and some simple examples. In this
section we will do some more elaborate things with them.

Creating a Census Tracts Table
------------------------------

We have already created a table in the database named `nyc_census_sociodata`. The table includes
interesting socioeconomic data about New York: commute times, incomes,
and education attainment. There is just one problem. The data are
summarized by "census tract" and we have no census tract spatial data!

In this section we will
-   Create a spatial table for census tracts
-   Join the attribute data to the spatial data
-   Carry out some analysis using our new data


### Creating a Census Tracts Table

We can build up higher level
geometries from the census block by summarizing on substrings of the
`blkid` key. In order to get census tracts, we need to summarize
grouping on the first 11 characters of the `blkid`.

    360610001001001 = 36 061 000100 1 001

    36     = State of New York
    061    = New York County (Manhattan)
    000100 = Census Tract
    1      = Census Block Group
    001    = Census Block

Create the new table using the **ST_Union** aggregate:

```
-- Make the tracts table
CREATE TABLE nyc_census_tract_geoms AS
SELECT 
  ST_Union(geom) AS geom, 
  SubStr(blkid,1,11) AS tractid
FROM nyc_census_blocks
GROUP BY tractid;

-- Index the tractid
CREATE INDEX nyc_census_tract_geoms_tractid_idx 
  ON nyc_census_tract_geoms (tractid);
```{{execute}}

### Join the Attributes to the Spatial Data

Join the table of tract geometries to the table of tract attributes with
a standard attribute join

```
-- Make the tracts table
CREATE TABLE nyc_census_tracts AS
SELECT 
  g.geom,
  a.*
FROM nyc_census_tract_geoms g
JOIN nyc_census_sociodata a
ON g.tractid = a.tractid;

-- Index the geometries
CREATE INDEX nyc_census_tract_gidx 
  ON nyc_census_tracts USING GIST (geom);
```{{execute}}

### Answer an Interesting Question

Answer an interesting question! "List top 10 New York neighborhoods
ordered by the proportion of people who have graduate degrees."

```
SELECT 
  100.0 * Sum(t.edu_graduate_dipl) / Sum(t.edu_total) AS graduate_pct, 
  n.name, n.boroname 
FROM nyc_neighborhoods n 
JOIN nyc_census_tracts t 
ON ST_Intersects(n.geom, t.geom) 
WHERE t.edu_total > 0
GROUP BY n.name, n.boroname
ORDER BY graduate_pct DESC
LIMIT 10;
```{{execute}}

We sum up the statistics we are interested, then divide them together at
the end. In order to avoid divide-by-zero errors, we don't bother
bringing in tracts that have a population count of zero.

    graduate_pct |       name        | boroname  

> --------------+-------------------+----------- 
>     47.6 | Carnegie Hill | Manhattan>
>     42.2 | Upper West Side | Manhattan 
>     41.1 | Battery Park | Manhattan
>     39.6 | Flatbush | Brooklyn 
>     39.3 | Tribeca | Manhattan 
>     39.2 | North Sutton Area | Manhattan 
>     38.7 | Greenwich Village | Manhattan 
>     38.6 | Upper East Side | Manhattan 
>     37.9 | Murray Hill | Manhattan 
>     37.4 | Central Park | Manhattan

> **Note**
> 
> New York geographers will be wondering at the presence of "Flatbush" in
> this list of over-educated neighborhoods. The answer is discussed in the
> next section.

Now let's move on to seeing how we can actually join between two different polygon data sets.