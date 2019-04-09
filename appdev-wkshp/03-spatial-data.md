# Working with Spatial Data in PostGIS

PostgreSQL has the Gold Standard in spatial extensions for any RDBMs on the market - PostGIS. If you have data that has 
direct spatial information, like coordinates, or indirect, such as an address, you can leverage the power of spatial 
analysis to enhance the insights into your dataIn the workshopwe will barely be scratching the surface of what you can 
do with PostGIS so please don't consider this exhaustive in the slightest.

Final note before we dig in, remember that usually to work with spatial data you need to 

```CREATE EXTENSION postgis;```

in your database to enable all the functionality. We don't have to do it in the workshop because we already enabled the 
extension when we created the DB in the container. 

#### Simple spatial query

Let's start with one of the simplest queries, a distance query. Let's find the 3 counties closest to the geographic center 
of the United States (including Alaska and Hawaii):  44.967244 Latitude, -103.771555 Longitude. This query is only going
to use a postGIS function:

Let's first refresh our memory about what columns are in the *county_geometry* table:

```\d county_geometry ```{{execute}}

Now let's select the id, county names, and distance from the 3 closest counties using the 
[ST_Distance function](https://postgis.net/docs/manual-2.5/ST_Distance.html):

```SELECT id, county_name, ST_Distance('POINT(-103.771555 44.967244)'::geography, the_geom) FROM county_geometry ORDER BY ST_Distance('POINT(-103.771555 44.967244)'::geography, the_geom) LIMIT 3;```{{execute}} 

This result may take a while to return because we are calculating the distance between all the counties in the U.S. and 
that point so we can ORDER the results on it. But I mentioned that PostGIS was the gold standard for a reason. It has a 
method to handle our use case. It's called a K Nearest Neighbor Search (KNN) with 
[its own operator](http://postgis.net/workshops/postgis-intro/knn.html).

```SELECT id, county_name, ST_Distance('POINT(-103.771555 44.967244)'::geography, the_geom) FROM county_geometry ORDER BY the_geom <-> 'POINT(-103.771555 44.967244)'::geography LIMIT 3;```{{execute}}

When we have a spatial index on the column, set a relatively small limit (X) on the return,  and we use the <-> operator, the database 
"knows" to find the first X spatially closest results and then calculate everything else on them. Spatial indices to the
rescue!

#### Spatial Join

This next query will demonstrate joining data based on spatial co-incidence rather than a shared primary key-foreign key 
relationship. Our example will be to join the storm location data to the county geometry data, given us the county of the 
incident eventhough it is not in our original file.

```select geo.statefp, geo.county_name, geo.aland, se.event_id, se.location from county_geometry as geo, se_locations as se where ST_Covers(geo.the_geom, se.the_geom) limit 10;```{{execute}}

The spatial operator we use is [ST_Covers](https://postgis.net/docs/ST_Covers.html) which return a boolean if the second geometry is completely withing the first geometry. 
We set the limit to 5 because we don't want to wait for all the results to return for over 48K rows. The results also show 
the [state fips](https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code) code which tells us 
the state name given the number. This way we can check if their is a county with the name in that state as well as a 
location and if they two overlap.

#### Spatial buffer and then select

Finally let's do more complicated query that you could not do without sophisticated spatial operations. Suppose we were 
trying to put together emergency response centers in counties with high potential for storms. We are going to buffer 12 KM (about 8 miles) 
off a storm even center point and then select all the counties that intersect that buffered circle. We will use a grouping 
query to do a count of the storms circles per county.

First is the query returning all the counties with 22.5KM of a storm event location:

```select geo.statefp, geo.county_name, se.locationid from county_geometry as geo, se_locations as se where ST_intersects(geo.the_geom, ST_Buffer(se.the_geom, 12500.0))  limit 200;```{{execute}}


and then do the grouping and counting:

```
with all_counties as (
           select geo.statefp, geo.county_name, se.locationid from county_geometry as geo, se_locations as se where ST_intersects(geo.the_geom, ST_Buffer(se.the_geom, 12500.0)) limit 200
   )
   select statefp, county_name, count(*) from all_counties group by statefp, county_name order by statefp, count(*) DESC;
 ```{{execute}}

The _with x as ()_ syntax is called a [Common Table Expression](https://www.postgresql.org/docs/11/queries-with.html) 
(CTE) in PostgreSQL and makes writing subqueries a lot easier. The CTE create a temporary table that exists for just 
one query. The tradeoff is that they are an optimization boundary. In this case they are fine to use for the workshop but 
if you use them in future work please dig deeper into the tradeoffs of CTEs. 

## Final Note

Today we worked with a Geography type for our spatial data because our geographic extent was the entire U.S. and it
also made our calculations easier syntax wise as well as being accurate. This is also the data format you get natively from
GPS units, such as from your phone.   

In the future, if you deal with data of a geographic extent less than a province or state, you are going to need to learn 
to work with coordinate systems and projections of your coordinates (basically the process to take a globe and make a map).

The way you specify your coordinates would change, since you would now have to give the projection you are using. Local 
governments, non-profits, and companies will using give you the coordinates in a projected system so you will need to learn 
how to use it in PostGIS. The ideas above remain exactly the same, it's just the way you store your data will change.

To learn more, there is a great, but slightly outdated, [discussion](http://postgis.net/workshops/postgis-intro/geography.html) in this other workshop content.
 
   