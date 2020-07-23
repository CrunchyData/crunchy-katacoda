A common analogy used to describe the role of database indexes is the index 
section at the back of a book. The index helps you quickly find 
specific terms or key words as used throughout the book. In the context of 
databases, the index stores information on where a data row is located in a table. 
The database goes to the index and then uses that information to retrieve the 
requested data.

Each relational database management system may have its own particular ways of 
how exactly an index is implemented, but generally speaking:

1. Each index works on one relation* - more specifically, the index is based on a 
column (or columns) in that relation.
2. Indexes are automatically created for primary key and unique constraint 
columns.
3. The database query planner takes into account the indexes available when 
determining the best _path_ for executing a query.

It's also worth noting that an index not only helps with retrieving data (i.e. 
the WHERE part of the query), it might even help with joins, or sorting the 
results set (i.e. the ORDER BY clause).

Indexes are their own data structures, and they're also stored on disk along 
with data tables and other objects. Postgres supports several different index 
types. The most common type is [b-tree](https://en.wikipedia.org/wiki/B-tree) 
(which stands for "Balanced Tree"). B-tree is used by default when you create a
 new index and don't specify an index type.

Query tuning and optimizing is a pretty big topic, and something that database 
administrators focus heavily on. With that said, anyone using a database system
 can benefit from having general knowledge on the role that indexes play. 

\***Note:** in the next steps we'll be working with table indexes. Indexes can be 
created for materialized views as well, so we say "relation" here.
