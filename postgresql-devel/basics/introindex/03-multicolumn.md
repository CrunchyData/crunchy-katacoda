Indices aren't always created for single columns only - Postgres also supports 
multicolumn indices. These can be useful if you know that you'll be querying 
a lot on multiple columns at once. 

For example, in this database, we know that 
we'll frequently want to retrieve storm event details based on the state and month.
Let's use EXPLAIN ANALYZE again to see how the query planner works this out:

```
EXPLAIN ANALYZE
SELECT * FROM se_details 
WHERE state = 'Florida' and month_name = 'August';
```{{execute}}

Now we'll add a multicolumn index for the combination of state and month_text. The syntax is the same - we just need to include both columns inside the parentheses like so:

```
CREATE INDEX idx_state_month ON se_details(state,month_name);
```{{execute}}

And let's run that EXPLAIN query one more time:

```
EXPLAIN ANALYZE
SELECT * FROM se_details 
WHERE state = 'Florida' and month_name = 'August';
```{{execute}}


### List database indices

Recall from the [Intro to psql](https://learn.crunchydata.com/postgresql-devel/courses/basics/intropsql) scenario that the `\d` command displays 
information on database objects. We can use this to view all indices for a given table:

`\d se_details`{{execute}}

Additionally you can also use the following psql command to see table and index sizes on disk:

`\dit+`{{execute}}

(`di+` will display information on indices only.)

Index information is stored in the `pg_indexes` view, which can also be queried on, for example: 

```
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'groot';
```{{execute}}
