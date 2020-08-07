# GIN index
GIN is an acronym which stands for Genealized Inverted Index. 

## Purpose
GIN indexes are quite different from the B-Tree indices in that they have the ability to have multiple keys per row. From the [official doc](https://www.postgresql.org/docs/9.5/gin-intro.html):

> GIN is designed for handling cases where the items to be indexed are composite values, and the queries to be handled by the index need to search for element values that appear within the composite items. For example, the items could be documents, and the queries could be searches for documents containing specific words.
>
>We use the word item to refer to a composite value that is to be indexed, and the word key to refer to an element value. GIN always stores and searches for keys, not item values per se.
 
> A GIN index stores a set of (key, posting list) pairs, where a posting list is a set of row IDs in which the key occurs. The same row ID can appear in multiple posting lists, since an item can contain more than one key. Each key value is stored only once, so a GIN index is very compact for cases where the same key appears many times. 

Out of the box GIN ships with binding for JSON, almost all primary type Arrays, and Full Text (tsvector). Since all of these data types have composite values where you want to search for values in the field, these are a reasonable default set of datatypes. For example, in a JSON document you might want to search for values associated with an attribute that is 3 levels deep in the JSON tree.

There is also [an extension](https://www.postgresql.org/docs/current/btree-gin.html) that allows you to build a B-Tree index in the GIN index. You would use this when you are doing a multi-column index that includes one of the base datatypes combined with JSON or Arrays. 

## Operators
The [official documentation](https://www.postgresql.org/docs/current/gin-builtin-opclasses.html) has a good listing of the operators and datatypes that come out of the box with GIN. Go ahead and click the link above which should open the table in a separate browser tab. [Here](https://www.postgresql.org/docs/current/functions-array.html#ARRAY-OPERATORS-TABLE) is all the operators for arrays. So if you look at the two pages together, you can see that a GIN index can help with:
 
1. Array Equality
2. Array Containment
3. Array Contained By
4. Array Overlap

All other array operators will not be able to use the GIN index to speed up operations.

Today we will make a simulated array table for examining GIN indexes.

## Size and Speed

Let's start by create a table to hold our arrays of integers:

```sql92
create table myarrays (
id int,
thearray int[]
);
```{{execute}}

We are going to create a 3 element array that contains integers between 0 and 1000. Let's create 15,000 entries in the table:

```sql92
insert into myarrays values (generate_series(1,15000), array[floor(random() * 1000)::int, floor(random() * 1000)::int,floor(random() * 1000)::int]); 
```{{execute}}

Let's look at the size of the table

```sql92
select
    pg_size_pretty(sum(pg_column_size(thearray))) as total_size,
    pg_size_pretty(avg(pg_column_size(thearray))) as average_size,
    sum(pg_column_size(thearray)) * 100.0 / pg_relation_size('myarrays') as percentage,
     pg_size_pretty(pg_relation_size('myarrays')) as table_size 
from myarrays;
```{{execute}}

The array column is 483 kB making up 46% of the total table size. 

### Before an Index

Now we can do a containment search on our array data. Let's look for all the arrays that contain 75 (NOTE: since we all generated different random arrays the timings will be different than you see here)

```sql92
select id, thearray from myarrays where thearray @> ARRAY[75];
```{{execute} 

Your result set should only contain rows where there is a 75 somewhere in the array. Now let's look at the timing for that query without a GIN index.

```sql92
explain analyze select id, thearray from myarrays where thearray @> ARRAY[75];
```{{execute}}

For my query I got an Execution Time of 3.2 milliseconds

Let's look at the timing for inserting another 15,000 rows but, just like we did for B-tree we will wrap it in a transaction so we don't actually insert the records.

```sql92
begin;
explain analyze insert into myarrays values (generate_series(1,15000), array[floor(random() * 1000)::int, floor(random() * 1000)::int,floor(random() * 1000)::int]);
rollback;
```{{execute}}

I got timings somewhere between 15 and 16 milliseconds. 

### After an Index

Now let's add our index to the Array column. 

```sql92
create index arry_idx on myarrays using GIN(thearray);
```{{execute}}

First, we will look at the size of the index

```sql92
\di+ arry_idx
```{{execute}}

I got an index size of 232 kB so the index is 50% the size of the actual column itself. 

Let's see what kind of speedup we get with the index. 

```sql92
explain analyze select id, thearray from myarrays where thearray @> ARRAY[75];
```{{execute}}

I am getting times around 0.18 milliseconds, that's a 17X improvement in search speed!

Now, let's look at the affect on inserts and increased index size if we insert another 15K rows:

```sql92
begin;
explain analyze insert into myarrays values (generate_series(15000, 30000), array[floor(random() * 1000)::int, floor(random() * 1000)::int,floor(random() * 1000)::int]);

select    pg_size_pretty(sum(pg_column_size(thearray))) as total_size,
    pg_size_pretty(avg(pg_column_size(thearray))) as average_size,
    sum(pg_column_size(thearray)) * 100.0 / pg_relation_size('myarrays') as percentage,
     pg_size_pretty(pg_relation_size('myarrays')) as table_size
from myarrays;
\di+ arry_idx
rollback;
```{{execute}}

The inserts took about 33 milliseconds which is twice as slow as the non-indexed insert. We can also see that our column has grown linearly in size but our index has grown 10X in size to 2248 kB. 
 
The GIN index does a nice job of showing the tradeoffs you need to consider when making an index on a column.

Now lets look at GIST indexes.

