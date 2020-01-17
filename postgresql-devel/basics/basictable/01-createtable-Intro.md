
Introduction
------------

Before we start working on our business scenario lets create test table with one field. To create a new table in PostgreSQL, you use the CREATE TABLE statement. So we will create table, insert a row and check the data.

Go ahead and execute the following SQL statement in the console.

```postgresql
CREATE TABLE test_table (name varchar);

INSERT INTO test_table VALUES 
  ('TestTable 1');
  
Select * form test_table;

```{{execute}}


Business Scenario Tables
------------------------

Let start analyzing business scenario using nouns to identify tables and verbs to identify relationships between tables. Below are  identified tables and fields.  

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
    
