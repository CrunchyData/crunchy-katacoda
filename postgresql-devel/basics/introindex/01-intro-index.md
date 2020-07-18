A common analogy used to describe the role of database indices is the index 
section at the back of the book. The book's index helps you quickly find 
specific terms or key words as used throughout the book.

Each relational database management system may have its own particular ways of 
how exactly to implement indices, but generally speaking:

1. Each index works on one relation* - more specifically, the index is based on a 
column (or columns) on that relation.
2. Indices are automatically created for primary key and unique constraint 
columns.
3. The database query planner takes into account the indices available when 
determining the best _path_ for executing a query.

Indexes are their own data structures, and they're also stored on disk. 
PostgreSQL supports several different index types, with [b-tree](https://en.wikipedia.org/wiki/B-tree)
 the type that's used by default when doing a CREATE INDEX.

Query tuning and optimizing is a pretty big topic, and something that database 
administrators focus heavily on. With that said, anyone using a database system
 can benefit from having general knowledge on the role that indices play. 

\***Note:** in the next steps we'll be working with table indices. Indices can be 
created for views as well, so we say "relation" here.
