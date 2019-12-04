Polygon/Polygon Joins
==================

In our interesting query we used the
**ST_Intersects(geometry_a, geometry_b)** function to determine which
census tract polygons to include in each neighborhood summary. Which
leads to the question: what if a tract falls on the border between two
neighborhoods? It will intersect both, and so will be included in the
summary statistics for **both**.

![image](joins_advanced/assets/centroid_neighborhood.png)

To avoid this kind of double counting there are two methods:

-   The simple method is to ensure that each tract only falls in **one**
    summary area (using **ST_Centroid(geometry)**)
-   The complex method is to divide crossing tracts at the borders
    (using **ST_Intersection(geometry,geometry)**)

Here is an example of using the simple method to avoid double counting
in our graduate education query:

```
SELECT 
   100.0 * Sum(t.edu_graduate_dipl) / Sum(t.edu_total) AS graduate_pct,
   n.name, n.boroname
FROM nyc_neighborhoods n 
JOIN nyc_census_tracts t 
ON ST_Contains(n.geom, ST_Centroid(t.geom)) 
WHERE t.edu_total > 0
GROUP BY n.name, n.boroname
ORDER BY graduate_pct DESC
LIMIT 10;
```{{execute}}

Note that the query takes longer to run now, because the ST_Centroid
function has to be run on every census tract.

```
graduate_pct |        name         | boroname  
--------------+---------------------+----------- 
   48.0 | Carnegie Hill | Manhattan
   44.2 | Morningside Heights | Manhattan 
   42.1 | Greenwich Village | Manhattan 
   42.0 | Upper West Side | Manhattan 
   41.4 | Tribeca | Manhattan 
   40.7 | Battery Park | Manhattan 
   39.5 | Upper East Side | Manhattan 
   39.3 | North Sutton Area | Manhattan 
   37.4 | Cobble Hill | Brooklyn 
   37.4 | Murray Hill | Manhattan
```

Avoiding double counting changes the results!

### What about Flatbush?

In particular, the Flatbush neighborhood has dropped off the list. The
reason why can be seen by looking more closely at the map of the
Flatbush neighborhood in our table.

![image](joins_advanced/assets/nyc_tracts_flatbush.jpg)

As defined by our data source, Flatbush is not really a neighborhood in
the conventional sense, since it just covers the area of Prospect Park.
The census tract for that area records, naturally, zero residents.
However, the neighborhood boundary does scrape one of the expensive
census tracts bordering the north side of the park (in the gentrified
Park Slope neighborhood). When using polygon/polygon tests, this single
tract was added to the otherwise empty Flatbush, resulting in the very
high score for that query.

