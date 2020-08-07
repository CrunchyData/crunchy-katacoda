# BRIN index

The BRIN index is really useful in a very narrow use case, but in that use case it is VERY useful. BRIN stands for Block Range Index. A block is PostgreSQLs base unit of storage, typically 8 kB. The index, by default, samples 128 blocks in a row and stores the start value in the first block and the end value in the last block. Then each entry in the index contains the location on the first block on disc and the range of values for the block range (128 blocks).  

Since the data is put on disc in order, the index ranges will be in order as well. So when a query looks for a value it does a scan of the index and finds all the ranges that might contain the values of interest and then does a disc scan of the relevant block ranges.  

## Purpose 
BRIN indexes are very good for tables that meet the following conditions:

1. Very large table (probably at least 1,000,000 rows). Below this amount and a B-Tree is usually a better choice for an index. 
2. Insert and reads only (updates or deletes quickly ruin the efficiency by making the block ranges contain non-continuous values)
3. The column you want to index is inserted in order. BRIN index relies on related data being written close together on disc.    

Examples of things people use BRIN indexes for are log records from server, financial transactions, or data feeds from IoT like sensors. All of these streams of data usually come in order based on timestamp, the data is not edited or deleted, and there are large volumes of data. 

Because the index covers 128 blocks of data with 3 main values, disc location, start of range, end of range, they are extremely small and efficient (there are several more columns in the index but they are mostly booleans). With BRIN indexes the whole index can often be read into memory or read very quickly off disc. 

If you are finding that the indexes are not specific enough you can tell the index to use range sizes smaller than 128 blocks but this will also come with in an increase in size for the index. There is an exercise at the end where you can play with block range size.

## Operators
BRIN index ships with operator bindings for most of the default datatypes. There is a complete list of the operators found in [table 67.1](https://www.postgresql.org/docs/current/brin-builtin-opclasses.html) of the official documentation.

Besides the typical >, <, =  operators for the usual datatypes, the operators for network types is very interesting. With BRIN indexes and network datatypes the query planner can use the index to look at questions [of containment](https://www.postgresql.org/docs/current/functions-net.html) as well, such as && or >>. For example you can ask a query like, is this inet range contained in this other range:

`inet '192.168.1/24' && inet '192.168.1.80/28'`

The problem with using network types is making sure they inet addresses are inserted into the table in order. 

You can also use BRIN indexes with range types and get most of the same operators we saw with GIST indexes in the previous exercise. Again though, this requires that the ranges are inserted in either ascending or descending order.

## Size and Speed
For this exercise we don't have any existing tables that meet the three conditions above. For simplicity we will create a single column table of integers and fill it with 1 million incrementing values.

```sql92
create table brinme (
id int
);
insert into brinme values (generate_series(1,1000000));
```{{execute}}

### Before an Index

Let's look at table size:


```sql92
select
    pg_size_pretty(sum(pg_column_size(id))) as total_size,
    pg_size_pretty(avg(pg_column_size(id))) as average_size,
    sum(pg_column_size(id)) * 100.0 / pg_relation_size('brinme') as percentage,
     pg_size_pretty(pg_relation_size('brinme')) as table_size 
from brinme;
```{{execute}}

Our column is only 4 MB in size.

Let's do a query to look for the id = 99000

```sql92
explain analyze select id from brinme where id = 99000; 
```{{execute}}

I get query times between 45 and 55 milliseconds.

Finally, let's go ahead and add a million more rows and look at timing:

```sql92
begin;
explain analyze insert into brinme values (generate_series(1000001,2000000));
rollback;
```{{execute}}

Which takes between 956 and 1174 milliseconds.

### After an Index

First we create our index:

```sql92
create index brinme_brin_idx on brinme using brin (id); 
```{{execute}}

Then we look at size of the index:

```sql92
\di+ brinme_brin_idx
```{{execute}}

The BRIN index is incredibly efficient with 1 million records being reduced to an index only 48 kB in size. 

Now let's look at the timing for our query:

```sql92
explain analyze select id from brinme where id = 99000; 
```{{execute}}

I get speeds between 5 and 7 milliseconds which is almost an order of magnitude faster. 

Finally, let's look at insert speeds:

```sql92
begin;
explain analyze insert into brinme values (generate_series(1000001,2000000));
rollback;
```{{execute}}

I am seeing between 1400 and 1800 milliseconds which is about 50% slower



If you want to play around some more you can drop the index and recreate it with a smaller block range using the following commands:

```sql92
drop index brinme_brin_idx;
create index brinme_brin_idx on brinme using brin (id) with (pages_per_range = 4 ); 
\di+ brinme_brin_idx
explain analyze select id from brinme where id = 99000; 
```{{execute}}

For me, I saw the index go from 48K to 64K but my search time went down from about 6 milliseconds to 0.9 milliseconds. 

Again, when your table meets the right conditions, the BRIN index can give you quite the optimization in your queries for a very small cost relative to other index types.

Crunchy Data has two [interesting](https://info.crunchydata.com/blog/postgresql-brin-indexes-big-data-performance-with-minimal-storage) blog [posts](https://info.crunchydata.com/blog/avoiding-the-pitfalls-of-brin-indexes-in-postgres) about using BRIN indexes. 