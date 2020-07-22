# B-Tree Index
B-tree in PostgreSQL stands for [balanced tree index](https://en.wikipedia.org/wiki/B-tree) and is an indexing scheme that is the default when you create an index. B-trees work well on a data type that is continually sortable on at least 1 dimension. They have [several](https://use-the-index-luke.com/sql/anatomy/the-tree) nice properties which make them very efficient in terms of size and speed for searching through data. 

The index creates a data structure made up of nodes, branches, and leaves (the final pages on disk to access) that divides up the data for quick retrieval. The size of the tree tends to grow slowly (logarithmicly) and therefore provides a small data structure that can often fit in memory even for the largest data sets. 

## Purpose

As mentioned in the introduction, since PostgreSQL ships with B-tree operator classes for all the default data types, the B-tree index will be the type you will use most often. In general, start with a B-tree index and if that doesn't work then look to other index types. Certain advanced data types, like full-text, JSON, or PostGIS data will not work with B-tree in the way you expect. 

## Operators
From the PostgreSQL [documentation](https://www.postgresql.org/docs/12/indexes-types.html)

> \<
>
> \<=
>
> \=
>
> \>=
>
> \>
>
> Constructs equivalent to combinations of these operators, such as BETWEEN and IN, can also be implemented with a B-tree index search. Also, an IS NULL or IS NOT NULL condition on an index column can be used with a B-tree index.
>
>The optimizer can also use a B-tree index for queries involving the pattern matching operators LIKE and ~ if the pattern is a constant and is anchored to the beginning of the string — for example, col LIKE 'foo%' or col ~ '^foo', but not col LIKE '%bar'... It is also possible to use B-tree indexes for ILIKE and ~*, but only if the pattern starts with **non-alphabetic** characters, i.e., characters that are not affected by upper/lower case conversion.

<> or != is covered as the negation of the = operator

## Size  

Let's go ahead and make some B-tree indices on different columns and see their disk size and difference they make in query times. 