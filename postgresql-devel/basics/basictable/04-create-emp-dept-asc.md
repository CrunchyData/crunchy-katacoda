

The employee department association table will demonstrate the foreign key functionality.

A FOREIGN KEY constraint specifies that the values in a column (or a group of columns) must match the values appearing in some row of another table. We say that this maintains the referential integrity between two related tables.

We want to ensure that the `employee_department_asc` table only contains records of employees and departments that actually exist. So, we define a foreign key constraint in the `employee_department_asc` table that references both the Employee and Department tables.

```
CREATE TABLE employee_department_asc (
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
```{{execute}}

Let's review the table structure:

```\d employee_department_asc```{{execute}}

- `employee_id` is of data type INTEGER and has a not null constraint.
- `department_number` is of data type INTEGER and has a not null constraint.
- `employee_department_start_date` is of data type DATE and has a not null constraint.
- `employee_department_end_date` is of data type DATE and can be null.

Constraints:
- `employee_department_pk` is a composite primary key constraint of two fields, `employee_id` and `department_number`. Remember, PostgreSQL automatically creates a unique index when a unique constraint or primary key is defined for a table. You'll see `"employee_department_pk" PRIMARY KEY, btree (employee_id, department_number)` in the Indexes section.
- The `employee_id_fk` foreign key constraint in this table references the Employee (`employee_id`) table. 
- The `department_number_fk` foreign key constraint in this table references the Department (`department_number`) table. 

Please note that Postgres does not create foreign key indexes automatically like it does for primary key. So, we created an index using the `CREATE INDEX` statement. You can see `"department_number_idx" btree (department_number)` under Indexes.

Let's continue.
