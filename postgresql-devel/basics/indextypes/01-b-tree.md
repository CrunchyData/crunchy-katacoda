# B-Tree Index
B-tree in PostgreSQL stands for [balanced tree index](https://en.wikipedia.org/wiki/B-tree) and is an indexing scheme that is the default when you create an index. B-trees work well on a data type that is continually sortable on at least 1 dimension. They have [several](https://use-the-index-luke.com/sql/anatomy/the-tree) nice properties which make them very efficient in terms of size and speed for searching through data. 

The index creates a data structure made up of nodes, branches, and leaves (the final pages on disk to access) that divides up the data for quick retrieval. The size of the tree tends to grow slowly (logarithmicly) and therefore provides a small data structure that can often fit in memory even for the largest data sets. 

## Purpose

As mentioned in the introduction, since PostgreSQL ships with B-tree operator classes for all the default data types, the B-tree index will be the type you will use most often. In general, start with a B-tree index and if that doesn't work then look to other index types. Certain advanced data types, like full-text, JSON, or PostGIS data will not work with B-tree in the way you expect. 

## Operators
From the PostgreSQL [documentation](https://www.postgresql.org/docs/12/indexes-types.html)

> <
> <=
> =
> \>=
> \>
>
> Constructs equivalent to combinations of these operators, such as BETWEEN and IN, can also be implemented with a B-tree index search. Also, an IS NULL or IS NOT NULL condition on an index column can be used with a B-tree index.
>
>The optimizer can also use a B-tree index for queries involving the pattern matching operators LIKE and ~ if the pattern is a constant and is anchored to the beginning of the string — for example, col LIKE 'foo%' or col ~ '^foo', but not col LIKE '%bar'... It is also possible to use B-tree indexes for ILIKE and ~*, but only if the pattern starts with **non-alphabetic** characters, i.e., characters that are not affected by upper/lower case conversion.

<> or != is covered as the negation of the = operator. If you are going to want to take advantage of the index with `like` queries then it is important to understand the first section of [this documentation](https://www.postgresql.org/docs/12/indexes-opclass.html) on operator classes and families. In particular, with text columns you need to make sure you use the right operator class that matches your "string" column, text, char, or varchar.

## Size and Speed  

Let's go ahead and make some B-tree indexes on different columns and see their disk size and difference they make in query times. 


We'll start by getting some information on the *storm event* table and the column which tells us which United States state the storm occurred "state". 

First let's look at some of the data.

> NOTE: if you click in the black box below it will cause the code to execute in the terminal on the right

```sql92
select state from se_details limit 5;
``` 

We can see that column stores textual data and is the state name in all upper case characters.

Now let's look at some statistics of the column versus the overall table:

```sql92
select
    pg_size_pretty(sum(pg_column_size(state))) as total_size,
    pg_size_pretty(avg(pg_column_size(state))) as average_size,
    sum(pg_column_size(state)) * 100.0 / pg_total_relation_size('se_details') as percentage,
     pg_size_pretty(pg_total_relation_size('se_details')) as table_size 
from se_details;
```

We can see that the data in the column is relatively small in size and is not a large percentage of the overall table size. 

### Before an index

Next let's look at how long it takes to query all the storms that happened in New York state (the state where I grew up). We are adding an index to this column because people may often want to query based on their home state or sort the output by the state. 

```sql92
explain analyze select event_id, state from se_details where state = 'NEW YORK';
```

We can see that query planner did a sequential scan (Seq Scan) and the "Execution Time" tells us this query took 34.41 milliseconds (times may be slightly different depending on the load on your machine). 

Finally, let's see how long and insert takes. The timing on inserts are so fast that if we "benchmark" this, there is too much variation to see the difference clearly. Therefore, we are going to insert 1000 values using simulated data and UUIDs. We are generating our UUIDs using  

Since Explain Analyze actually carries out the transaction, we are going to wrap this statement in a transaction that we rollback. This way we don't change the data in the table.

```sql92

begin;
explain analyze insert into se_details (event_id, state) values (generate_series(100000,101000), gen_random_uuid());
rollback;
```

And we can see that carrying out the insert took about 0.324 milliseconds (again timing may vary on your machine). 

### After Index

Let's go ahead and make an index on the state column. The syntax for this is relatively straight forward:

```sql92
create index se_details_state_idx on se_details(state);  
```
Since we didn't specify a USING = METHOD on this call the index takes the default, which is B-tree.
Given our small our table is, the indexing operation should be extremely quick. 

Now let's look at the size of the index:

```sql92
\di+ se_details_state_idx;
```

You can see that the index has a total size a little over 3x the original data in the column. The size of the index will grow at a slower **rate** than the size of the data in teh actual column. 

Now let's look at the benefit we get from this added use of space.

First let's do our same simple query again:

```sql92
explain analyze select event_id, state from se_details where state = 'NEW YORK';
```
We can see that the query planner used the index because the first node in the query plan (the one farthest down in the output) used a Bitmap Index Scan on our index. I did 3 runs of this query and I got a maximum run time of 13.5 milliseconds and minimum run time of 1.72 milliseconds, giving me an approximate 2x to 20x speedup in query times!

You can see the query planner won't use the index if we also use the < operator:

```sql92
explain analyze select event_id, state from se_details where state < 'NEW YORK';
```

It doesn't use the index because over 50% of the data in the table is returned in this query (much more than 5-10% threshold for when an index scan is faster than a sequential scan).

But if we say we only want the states that come alphabetically after Wisconsin (which is just Wyoming), the query planner now uses the index.

```sql92
explain analyze select event_id, state from se_details where state >  'WISCONSIN';
```

This change in query plan occurs because we are now returning fewer rows so scan of the index and then the random access of the disk pages with the data is faster than the sequential scan.

Now let's wrap up by looking at how the B-tree index affects insert speed. Let's redo our  

STILL NEED TO LOOK AT INSERT

 
 