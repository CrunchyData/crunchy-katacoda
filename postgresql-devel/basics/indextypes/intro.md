# Different Index types in PostgreSQL
Indices are a key aspect to query performance and PostgreSQL has a very flexible implementation to handle different indexing schemes. This tutorial will introduce you to some of the major index types in PostgreSQL, helping you understand them a bit better and know the use cases where they apply. We assume you completed the [introduction to indices]() tutorial or are familiar with very basic concepts about indices.

One important fact about PostgreSQL is that all indices classes are run-time bindable. A bound index class has provided an [operator class](https://www.postgresql.org/docs/current/indexes-opclass.html) for a data type. This operator class provide a set of operators that the index will be able to use in queries.  An example might be the b-tree index type which has an operator class (op_class) for CHAR data type. It would define at least the *=* operator. By doing this, when your SQL contained a query like 

```select * from table WHERE char_column = 'hello'; ```

The query planner could use the b-tree index you had made on `char_column`.

This discussion is not as important for B-Tree indices because, by default, PostgreSQL comes "out of the box" with operator classes for all the built-in datatypes. Where this becomes more important as we talk about the other Index types.  

And with that introduction, let's get into the different indices. 
We have loaded a database with almost all of the data from the Crunchy Demo Data [repository](https://github.com/CrunchyData/crunchy-demo-data/) and we have logged you in to the `psql` prompt as:

user: groot

password: password

database: workshop
