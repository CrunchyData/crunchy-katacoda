Analyzing
---------

The PostgreSQL query planner intelligently chooses when to use or not to
use indexes to evaluate a query. Counter-intuitively, it is not always
faster to do an index search: if the search is going to return every
record in the table, traversing the index tree to get each record will
actually be slower than just linearly reading the whole table from the
start.

In order to figure out what situation it is dealing with (reading a
small part of the table versus reading a large portion of the table),
PostgreSQL keeps statistics about the distribution of data in each
indexed table column. By default, PostgreSQL gathers statistics on a
regular basis. However, if you dramatically change the make-up of your
table within a short period of time, the statistics will not be
up-to-date.

To ensure your statistics match your table contents, it is wise the to
run the `ANALYZE` command after bulk data loads and deletes in your
tables. This force the statistics system to gather data for all your
indexed columns.

The `ANALYZE` command asks PostgreSQL to traverse the table and update
its internal statistics used for query plan estimation (query plan
analysis will be discussed later).

```
ANALYZE nyc_census_blocks;
```{{execute}}

Vacuuming
---------

It's worth stressing that just creating an index is not enough to allow
PostgreSQL to use it effectively. VACUUMing must be performed whenever a
new index is created or after a large number of UPDATEs, INSERTs or
DELETEs are issued against a table. The `VACUUM` command asks PostgreSQL
to reclaim any unused space in the table pages left by updates or
deletes to records.

Vacuuming is so critical for the efficient running of the database that
PostgreSQL provides an "autovacuum" option.

Enabled by default, autovacuum both vacuums (recovers space) and
analyzes (updates statistics) on your tables at sensible intervals
determined by the level of activity. While this is essential for highly
transactional databases, it is not advisable to wait for an autovacuum
run after adding indices or bulk-loading data. If a large batch update
is performed, you should manually run `VACUUM`.

Vacuuming and analyzing the database can be performed separately as
needed. Issuing `VACUUM` command will not update the database
statistics; likewise issuing an `ANALYZE` command will not recover
unused table rows. Both commands can be run against the entire database,
a single table, or a single column.

```
VACUUM ANALYZE nyc_census_blocks;
```{{execute}}

Function List
-------------

[geometry_a &&
geometry_b](http://postgis.net/docs/geometry_overlaps.html): Returns
TRUE if A's bounding box overlaps B's.

[geometry_a =
geometry_b](http://postgis.net/docs/ST_Geometry_EQ.html): Returns TRUE
if A's bounding box is the same as B's.

[ST_Intersects(geometry_a,
geometry_b)](http://postgis.net/docs/ST_Intersects.html): Returns TRUE
if the Geometries/Geography "spatially intersect" - (share any portion
of space) and FALSE if they don't (they are Disjoint).