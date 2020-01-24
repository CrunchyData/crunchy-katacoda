
Let's create employee department association table, this table demonstrates the foreign key functionality. 

A foreign key constraint specifies that the values in a column (or a group of columns) must match the values appearing in some row of another table. We say this maintains the referential integrity between two related tables.

We want to ensure that the employee_department_asc table only contains records of employee and department that actually exist. So we define a foreign key constraint in the employee_department_asc table that references the employee and department table.


```postgresql
Create table employee_department_asc (
employee_id integer not null,
department_number integer not null,
employee_department_start_date date not null,
employee_department_end_date date null,
CONSTRAINT employee_department_pk primary key (employee_id,
department_number),
constraint employee_id_fk foreign key (employee_id) REFERENCES
employee (employee_id),
constraint department_number_fk foreign key (department_number)
REFERENCES department (department_number) );

create index department_number_idx on employee_department_asc
(department_number );
``` {{execute}}

Let's review the table structure 
```postgresql
\d employee_department_asc
``` {{execute}}

  - employee_id is of data type **INTEGER** and not null constraint.
  - department_number is of data type **INTEGER** and not null constraint.
  - employee_department_start_date is of data type **DATE** and not null
    constraint.
  - employee_department_end_date is of data type **DATE** and null
    constraint.
  - Constraints
      - employee_department_pk is a composite primary Key constraint
        with 2 fields employee_id and department_number. PostgreSQL
        automatically creates a unique index when a unique constraint or
        primary key is defined for a table. You can see
        "employee_department_pk" PRIMARY KEY, btree (employee_id,
        department_number)
      - employee_id_fk foreign key constraint in this table that
        references the employee (employee_id), table. A foreign key
        constraint specifies that the values in a column (or a group of
        columns) must match the values appearing in some row of another
        table. We say this maintains the referential integrity between
        two related tables.
      - department_number_fk foreign key constraint in this table that
        references the department (department_number) table. Please
        note Postgres does not create foreign key index automatically as
        it does for primary key. So we created an index using create
        index. You can see "department_number_idx" btree
        (department_number)

Let's continue.
