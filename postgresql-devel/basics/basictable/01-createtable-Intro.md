

Before we start working on our business scenario lets review what documentation states regarding create table 

- To create a new table in PostgreSQL, you use the CREATE TABLE statement. 

- CREATE TABLE will create a new, initially empty table in the current database. The table will be owned by the user issuing the command.

- The name of the table must be distinct from the name of any other table, sequence, index, view, or foreign table in the same schema.

- A constraint is an SQL object that helps define the set of valid values in the table in various ways.

Let's create test table with one field, Insert a row and Review data. 

Execute the following SQL statement in the console.

```postgresql
CREATE TABLE test_table (name varchar);

INSERT INTO test_table VALUES 
  ('TestTable 1');
  
Select * from test_table;

```{{execute}}


Business Scenario Tables
------------------------

Based on our data model let's elow are  identified tables and fields.  

  - Employee (This table captures information of employees working at
    the company)
    
      - Employee Id – number, auto generate, Primary Key, Unique and not
        null
    
      - Employee SSN – 10 character, unique and not null
    
      - Employee First Name – 35 characters and not null
    
      - Employee Last Name -- 50 characters and not null
    
      - Employee Start Date – date and not null
    
      - Employee Termination Date – date nullable

  - Department (This table captures information of department in the
    company)
    
      - Department Id – number auto generate, Primary Key, Unique and
        not null
    
      - Department Name – 50 characters and not null

  - Employee Department Association (This tables capture association
    information between employee and department, in short when and which
    employee worked or is working in the department)
    
      - Employee Id – number, Primary Key, not null, Reference from
        employee table
    
      - Department Number – number, Primary Key, not null, Reference
        from department table
    
      - Employee Department Start Date -- date and not null
    
      - Employee Department End Date -- date nullable

  - Employee Salary History (This table captures employee salary history
    over time)
    
      - Employee Id – number, Primary Key, not null, Reference
    
      - Employee Salary Start Date – date, Primary Key, and not null
    
      - Employee Salary amount – number and not null, and value greater
        than 1000
    
      - Employee End Date -- date nullable
    
