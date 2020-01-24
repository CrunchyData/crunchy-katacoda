

Let's create employee salary history table, this table demonstrates the foreign key functionality and check constraint. 

A check constraint is the most generic constraint type. It allows you to specify that the value in a certain column must satisfy a Boolean (truth-value) expression. For instance, employee_salary_amount > 1000.

Once we create the table we will review the table structure.

```postgresql
create table employee_salary_hist (
employee_id integer not null,
employee_salary_start_date date not null,
employee_salary_amount numeric(13,2) CONSTRAINT salary_ck1
CHECK(employee_salary_amount > 1000),
employee_salary_end_date date null,
CONSTRAINT employee_salary_pk primary key (employee_id,
employee_salary_start_date),
constraint employee_id_fk1 foreign key (employee_id) REFERENCES
employee (employee_id));
``` {{execute}}

Let's review the table structure.

```postgresql
\d employee_salary_hist
``` {{execute}}

  - employee_id is of data type **INTEGER** and not null constraint.
  - employee_salary_start_date is of data type **DATE** and not null
    constraint.
  - employee_salary_amount is of data type **NUMERIC** of length 13 and
    capture 2 digits after the decimal point.
  - employee_salary_end_date is of data type **DATE** and null
    constraint.
  - Constraints    
      - employee_salary_pk is a composite primary Key constraint with
        2 fields employee_id and employee_salary_start_date.
        PostgreSQL automatically creates a unique index when a unique
        constraint or primary key is defined for a table. You can see "
        employee_salary_pk " PRIMARY KEY, btree (employee_id,
        employee_salary_start_date)    
      - employee_id_fk1 foreign key constraint in this table that
        references the employee (employee_id), table. A foreign key
        constraint specifies that the values in a column (or a group of
        columns) must match the values appearing in some row of another
        table. We say this maintains the referential integrity between
        two related tables.    
      - Check constraint to make sure salary > 1000

Now that we have created all the tables, let's now undertand how all constraints work by inserting data in tables.

Let' move forward.
