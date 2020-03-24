


Before we start to create tables based on our business scenario, let's review some brief points:

a) To create a new table in PostgreSQL, you use the `CREATE TABLE` statement.

b) `CREATE TABLE` will create a new, initially empty table in the current database. The user issuing the create command will be the owner of the table.

c) The name of the table must be **distinct** from the name of any other table, sequence, index, view, or foreign table in the same schema.

d) A **constraint** is an SQL object that helps define the set of valid values that can be stored in the table.

Let's try creating a test table with one field (i.e. column). We'll also go ahead and insert a row, and then review the data.

Execute the following SQL statement in the console:

```
CREATE TABLE test_table (name varchar);

INSERT INTO test_table VALUES 
  ('TestTable 1');

SELECT * from test_table;
```{{execute}}

