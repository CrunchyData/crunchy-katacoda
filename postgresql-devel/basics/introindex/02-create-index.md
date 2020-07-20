Before we go to querying, first we'll enable expanded view in psql so the results set is more readable:

`\x`{{execute}}

Let's take a quick look at the data. Execute the query below by selecting the 
code block:

```
SELECT * FROM se_details WHERE event_type = 'Flash Flood'
LIMIT 5;
```{{execute}}

Let's take a look at what EXPLAIN (ANALYZE) gives us when we remove the limit from the query. We'll toggle extended display off this time:

`\x`{{execute}}

```
EXPLAIN ANALYZE 
SELECT * FROM se_details WHERE event_type = 'Flash Flood';
```{{execute}}

You should see output like this, where it indicates the execution time for the 
query:

![screenshot here]()

You'll also see that the query plan indicates a "Seq Scan," or a _sequential scan_. This means that it scans *each data row* in the table to see if it matches the query condition. You might be able to guess that for larger tables, a sequential scan could take up quite a bit of time!

## Get started with CREATE INDEX

In PostgreSQL, the CREATE INDEX command defines a new index. Let's go ahead 
and try creating a new index for our se_details table:

```
CREATE INDEX idx_evt_type ON se_details(event_type);
```{{execute}}

We name our index `idx_evt_type`. The name can also be left out - Postgres will generate a name based on the table and the indexed column(s) name.

We specify that we want the index on the `se_details` table with `ON se_details`, and the name of the column to be indexed goes inside the parentheses. 

We'll run the same EXPLAIN statement as above:

```
EXPLAIN ANALYZE 
SELECT * FROM se_details WHERE event_type = 'Flash Flood';
```{{execute}}

This time, you should see that the input indicates an index scan. The execution time is now a fraction of the previous one. Neat!
