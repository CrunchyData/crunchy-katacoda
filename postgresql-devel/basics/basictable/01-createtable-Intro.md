

Before we start create tables based on our business scenario lets review brief points of create table 

- To create a new table in PostgreSQL, you use the CREATE TABLE statement. 

- CREATE TABLE will create a new, initially empty table in the current database. The table will be owned by the user issuing the command.

- The name of the table must be distinct from the name of any other table, sequence, index, view, or foreign table in the same schema.

- A constraint is an SQL object that helps define the set of valid values in the table in various ways.


Let's create test table with one field, insert a row and review data. 

Execute the following SQL statement in the console.

```postgresql
CREATE TABLE test_table (name varchar);

INSERT INTO test_table VALUES 
  ('TestTable 1');
  
Select * from test_table;

```{{execute}}

