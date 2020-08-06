# GiST Index

GIST stands for Generalized Search-Tree. 

## Purpose
Remember, the B-tree operates based on the data that is naturally sortable so that <, >, and = can be used to generate the tree structure. This format won't work for things like geospatial objects or full-text search. The GiST, like its name implies, has the ability to create a tree structure using arbitrary "splitting" based on a custom operator. For example, in PostGIS, the GiST spatial indexing happens with an R-Tree under the hood. 

Any datatype you can describe with a split method and a compare method you can leverage the GIST infrastructure to make an index. 

Another benefit to using a GiST index is that the implementation can use keys that are derived from the data and not the data itself. In a B-Tree index for an integer column, the nodes in the tree are going to be integers. In the GiST for PostGIS spatial data, the index is built using the bounding boxes for the spatial features no matter the complexity of the shape. So the bounding box is used when going through the index but then it points to the data that it represents. 

This difference between keys in the index and the actual data often means that for GiST indexes there is an initial pass through the index to get candidate matches and then a second stage to check for exact matches. This double pass on the data can cause a degradation in search time. On the other hand, it will probably be faster than a search with no index at all, especially on things like complicated geometries or range overlap. 
   
There is an extension, [btree_gist](https://www.postgresql.org/docs/current/btree-gist.html), that uses the B-tree indexing inside the GiST, which is really useful if you want to combine spatial data and something like a text or integer field into a multi-column GiST index.

## Operators

In PostGIS (geospatial extension in PostgreSQL) the main operators that can take advantage of the GiST index are:

|  Operator |  Function |
|---|---|
|  @ | One geometry is contained by another   |
|  ~ |  One geometry contains another |
|  && |  One geometry intersects another |
|  <-> |   When used in an "ORDER BY" clause you get efficient nearest-neighbor results|


A GiST index can accelerate queries involving these range operators:

|  Operator |  Function |
|---|---|
|  = | Range equality |
|  && |  Range overlap |
|  <@ | Contains range or element   |
|  @> | Range or element is contained by range  |
|  << |  Strictly left of |
|  >> |  Strictly right of |
|  -&#124;- | Ranges are Adjacent  |
|  &< |  Does not extend to the right of |
|  &> |  Does not extend to the left of |

Per the official documentation, Full Text also supports GiST but GIN is [the recommended](https://www.postgresql.org/docs/current/textsearch-indexes.html) index type.

## Size and Speed

For this exercise we are going to use the PostGIS GiST indices on the County Geometry (county_geometry) table which contains the polygon outlines of all the counties (sub-state boundaries) in the USA. The database already has GiST indexes on the two geometry columns (interior_pnt and the_geom) so we need to drop the indices first to do our timing and size estimates.

```sql92
drop index countygeom_interiorpt_indx;
drop index countygeom_the_geom_indx;

``` 
### Before an Index
Like the last indexes, we will start with looking at the existing table size.

```sql92
select
    pg_size_pretty(sum(pg_column_size(the_geom))) as total_size,
    pg_size_pretty(avg(pg_column_size(the_geom))) as average_size,
    sum(pg_column_size(the_geom)) * 100.0 / pg_total_relation_size('county_geometry') as percentage,
     pg_size_pretty(pg_total_relation_size('county_geometry')) as table_size 
from county_geometry;
```{{execute}}

We can see that 120 of the 127 MB in the table are due to the polygon column. This large size makes sense since a polygon is often composed of many points that form the boundary.

 ```sql92
 select
     pg_size_pretty(sum(pg_column_size(interior_pnt))) as total_size,
     pg_size_pretty(avg(pg_column_size(interior_pnt))) as average_size,
     sum(pg_column_size(interior_pnt)) * 100.0 / pg_total_relation_size('county_geometry') as percentage,
      pg_size_pretty(pg_total_relation_size('county_geometry')) as table_size 
 from county_geometry;
 ```{{execute}}

At only 92 kB for the entire column, the interior center point of each county is a comparatively small column, since it is basically only two coordinates. 

We will do one query with the polygons and one query with the points. For point data we will find the 10 closest points to the geographic center of the United States by taking advantage of the <-> operator. For polygons we will find all the counties that share a boundary (intersect &&) the county I grew up in (Rockland County, NY). 

10 closest points near the geographic center of the US:
```sql92
explain analyze 
SELECT id, county_name, ST_Distance('POINT(-103.771555 44.967244)'::geography, interior_pnt) as meters FROM county_geometry ORDER BY interior_pnt <-> 'POINT(-103.771555 44.967244)'::geography LIMIT 10;
```{{execute}}

I am getting times between 8 and 12 milliseconds.

Now to search the bordering counties of Rockland County:

```sql92
explain analyze
with rockland as (
        select the_geom as rock_geom from county_geometry  where county_name = 'Rockland' 
    )
select county.county_name from county_geometry as county, rockland where rockland.rock_geom && county.the_geom; 
```{{execute}}

I am getting times between 18 and 25 milliseconds.

Now let's insert 5,000 random points into the point interior points column:

```sql92
begin;
explain analyze
insert into county_geometry (id, interior_pnt) values (generate_series(4000,9000), ST_geogfromtext('point(' || random() * -179 || ' ' || random() * 89 || ')'));
rollback;

```{{execute}}

The timings I am seeing for this are between 39 and 45 milliseconds.

### After an Index

Time to add an index to both our geometry columns:

```sql92
create index county_geometry_the_geom_idx  on county_geometry using gist(the_geom);
create index county_geometry_interior_pnt_idx  on county_geometry using gist(interior_pnt);

```{{execute}}

And now we can rerun our top 10 counties near the center of the U.S.A.:

```sql92
explain analyze 
SELECT id, county_name, ST_Distance('POINT(-103.771555 44.967244)'::geography, interior_pnt) as meters FROM county_geometry ORDER BY interior_pnt <-> 'POINT(-103.771555 44.967244)'::geography LIMIT 10;
```{{execute}}

For timings I am getting between 1.5 and 2 milliseconds which is almost an order of magnitude faster. 

Let's see what we get for the polygon search (which is even more intensive):

```sql92
explain analyze
with rockland as (
        select the_geom as rock_geom from county_geometry  where county_name = 'Rockland' 
    )
select county.county_name from county_geometry as county, rockland where rockland.rock_geom && county.the_geom; 
```{{execute}}

which now runs at 1.3 to 1.4 milliseconds, which is about 30x the original query times. 

But if we look at speed of inserts we see an almost of doubling of insert time:

```sql92
begin;
explain analyze
insert into county_geometry (id, interior_pnt) values (generate_series(4000,9000), ST_geogfromtext('point(' || random() * -179 || ' ' || random() * 89 || ')'));
rollback;

```{{execute}}

With that, we are done with GiST indexes and we can move on to our final type, BRIN.