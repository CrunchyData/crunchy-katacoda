A common analogy used to describe the role of database indices is the index 
section at the back of the book. The book's index helps you quickly find 
specific terms or key words as used throughout the book. In the context of 
databases, the index stores information on where a record is in the table. 
The database goes to the index and then uses that information to retrieve the 
requested data.

Each relational database management system may have its own particular ways of 
how exactly to implement indices, but generally speaking:

1. Each index works on one relation* - more specifically, the index is based on a 
column (or columns) on that relation.
2. Indices are automatically created for primary key and unique constraint 
columns.
3. The database query planner takes into account the indices available when 
determining the best _path_ for executing a query.

Indexes are their own data structures, and they're also stored on disk. 
Postgres supports several different index types. The most common type is [b-tree](https://en.wikipedia.org/wiki/B-tree) (which stands for "Balanced Tree"). B-tree is used by default when you create a new index and don't specify a specific other type.

Query tuning and optimizing is a pretty big topic, and something that database 
administrators focus heavily on. With that said, anyone using a database system
 can benefit from having general knowledge on the role that indices play. 

\***Note:** in the next steps we'll be working with table indices. Indices can be 
created for views as well, so we say "relation" here.
