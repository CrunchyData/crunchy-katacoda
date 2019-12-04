Large Radius Distance Joins
==================

A query that is fun to ask is "How do the commute times of people near
(within 500 meters) subway stations differ from those of people far away
from subway stations?"

However, the question runs into some problems of double counting: many
people will be within 500 meters of multiple subway stations. Compare
the population of New York:

``` 
SELECT Sum(popn_total)
FROM nyc_census_blocks;
```{{execute}}

    8175032

With the population of the people in New York within 500 meters of a
subway station:

```
SELECT Sum(popn_total)
FROM nyc_census_blocks census
JOIN nyc_subway_stations subway
ON ST_DWithin(census.geom, subway.geom, 500);
```{{execute}}

    10855873

There's more people close to the subway than there are people! Clearly,
our simple SQL is making a big double-counting error. You can see the
problem looking at the picture of the buffered subways.

![image](joins_advanced/assets/subways_buffered.png)

The solution is to ensure that we have only distinct census blocks
before passing them into the summarization portion of the query. We can
do that by breaking our query up into a subquery that finds the distinct
blocks, wrapped in a summarization query that returns our answer:

```
WITH distinct_blocks AS (
  SELECT DISTINCT ON (blkid) popn_total
  FROM nyc_census_blocks census
  JOIN nyc_subway_stations subway
  ON ST_DWithin(census.geom, subway.geom, 500)
)
SELECT Sum(popn_total)
FROM distinct_blocks;
```{{execute}}

    5005743

That's better! So a bit over half the population of New York is within
500m (about a 5-7 minute walk) of the subway.
