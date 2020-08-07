# Different Index types in PostgreSQL
Indexes are a key aspect to query performance and PostgreSQL has a very flexible implementation to handle different indexing schemes. This tutorial will introduce you to some major index types in PostgreSQL, helping you understand them a bit better and know the use cases where they apply. We assume you completed the [introduction to indexes]() tutorial or are familiar with very basic concepts about indexes. It also uses EXPLAIN ANALYZE to look at how indexes change query plans so we will also assume you understand the command or have done the [Crunchy Data class](https://learn.crunchydata.com/postgresql-devel/courses/basics/explain)

> This information we are about to discuss about run time binding, op_classes, and operators is not crucial to understanding the different index types. For now, you can just ignore it and do the exercises. After you do the exercises and see the examples it may make more sense. If you want to go deeper on indices in the future, then you will really need to understand these concepts.

One important fact about PostgreSQL is that all indexes classes are run-time bindable.  A bound index class (such as B-tree or GiST) has provided an [operator class](https://www.postgresql.org/docs/current/indexes-opclass.html) for a data type. This operator class provide a set of operators (such as =, <, or <->) that the index will be able to use to compare different values of the data type.  

An example might be the B-tree index class which has an operator class (op_class) for the CHAR data type. The op_class would define at least the *=* operator. By defining this operator, when your SQL contained a query like 

```select * from table WHERE char_column = 'hello'; ```{{execute}}

The query planner could use the B-tree index you had made on `char_column`. 

> Note: indexes may also be used to improve efficiency of ORDER BY or JOIN statements. Whether or not the index gets used for the WHERE, JOIN, or ORDER BY clauses is dependent on heuristics in the query planner. Factors, such as amount of data returned, disk access speed, and amount of memory, will all influence the query planner in choosing to use an index. 

The presence of operators is not as much of a concern for B-Tree indexes because, by default, PostgreSQL comes "out of the box" with operator classes for all the built-in datatypes. Where the availability of operators becomes more important is when we talk about the other Index types.  

One more important implication from the discussion above is that, depending on the index type you choose, operators (such as >, = , or @@ ) may or may not be used with your index in the query planner. That is, you can make the index, but the query planner cannot use the index with the operator in your WHERE clause because the op_class did not bind the operator to the datatype. In the following tutorials we will show you which operators can be used with which datatypes + index combination.   


And with that introduction, let's get into the different indexes. 
We have loaded a database with almost all of the data from the Crunchy Demo Data [repository](https://github.com/CrunchyData/crunchy-demo-data/) and we have logged you in to the `psql` prompt as:

user: groot

password: password

database: workshop
