One of the key performance features of PostgreSQL partitioning has existed since before it was native. That being `constraint exclusion`. This works for any constraint set using inheritance, not just partitioning. It means that if the planner can tell by looking at a set of tables' constraints that the desired data cannot possibly exist there, it is able to skip over having to further check that table's indexes or table data.

Native partitioning was able to enhance this feature even more with PostgreSQL 11+ by using what is called partition pruning. Since the constraint layout of the partition set is known, in some cases PostgreSQL can entirely skip having to look at each child table's constraints to see if they can be excluded. Since even the constraint check can be time consuming with larger partition sets, this can improve query performance even further.

Let's add some additional child tables to the first ranged partition set 

```
CREATE TABLE measurement_20060203 PARTITION OF measurement (PRIMARY KEY (city_id)) FOR VALUES FROM ('2006-02-03') TO ('2006-02-04');
CREATE TABLE measurement_20060204 PARTITION OF measurement (PRIMARY KEY (city_id)) FOR VALUES FROM ('2006-02-04') TO ('2006-02-05');
CREATE TABLE measurement_20060205 PARTITION OF measurement (PRIMARY KEY (city_id)) FOR VALUES FROM ('2006-02-05') TO ('2006-02-06');
CREATE TABLE measurement_20060206 PARTITION OF measurement (PRIMARY KEY (city_id)) FOR VALUES FROM ('2006-02-06') TO ('2006-02-07');
CREATE TABLE measurement_20060207 PARTITION OF measurement (PRIMARY KEY (city_id)) FOR VALUES FROM ('2006-02-07') TO ('2006-02-08');
```{{execute T1}}
as well as generate some data
```
INSERT INTO measurement (logtime) VALUES (generate_series('2006-02-01 00:00:00'::timestamptz, '2006-02-07 23:00:00'::timestamptz, '1 hour'::interval));
```{{execute T1}}
Now let's look at the explain plans of queries that try and get different ranges of data back.
```
EXPLAIN ANALYZE SELECT * FROM measurement WHERE city_id < 5;
```{{execute T1}}
Here you can see it has to check every child table since there is no constraint on what id values can exist in each child.
```
EXPLAIN ANALYZE SELECT * FROM measurement WHERE logtime < '2006-02-04'::date;
```{{execute T1}}
Now you can see that it only has to check the first 3 partitions in our set since that is the only possibly place the constraints will allow it to exist.




