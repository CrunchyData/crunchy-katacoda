Now that you've been introduced to the basics of indexes in Postgres and 
how they're used to speed up queries, you might be wondering: Should we create
 as many indexes as possible? What best practices are there related to indexes?

The quick answer is: You don't want to create indexes for _all_ the things. 
Indexes **come at a cost**, and these basically boil down to:

1. You can't (shouldn't) create an index on the fly just to speed up a one-off 
query. Indexes are defined before they can be used, and they take time to build
 especially for larger tables. 
2. Indexes are stored on disk, and so they also take up space. 
3. For each new data row inserted or existing data row updated, index entries 
have to be added or updated as well. Indexes can absolutely also have an impact
 on the performance of database write operations.
4. While an index is building, the database may _lock_ the table from inserts, 
updates, or deletes. Depending on the size of the index, that may mean the 
table is locked for a longer time. (There is an option to allow other database 
operations to proceed [concurrently](https://www.postgresql.org/docs/current/sql-createindex.html#SQL-CREATEINDEX-CONCURRENTLY).)

### Indexes aren't used all the time

It's also important to note that creating an index does not mean PostgreSQL 
will _always_ use it. For example, if there is a large enough number of rows 
that meet the query criteria, it might be more cost-effective for the database 
to skip reading the index entirely and just go straight to retrieving the 
requested records from the table. (A very rough estimate is between more than 
5 to 10% of rows in the table, and the range is _highly_ dependent on a number 
of other factors.) Run-time settings on the database server can also affect 
query plans and index usage.
