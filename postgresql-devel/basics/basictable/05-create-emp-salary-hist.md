

The Employee Salary History table will demonstrate the foreign key and check constraint functionality.

A CHECK constraint is the most generic constraint type. It allows you to specify that the value in a certain column must satisfy a Boolean (truth-value) expression: in this instance, employee_salary_amount > 1000.

Once we create the table we will review the table structure:

```CREATE TABLE employee_salary_hist (
employee_id integer not null,
employee_salary_start_date date not null,
employee_salary_amount numeric(13,2) CONSTRAINT salary_ck1
CHECK(employee_salary_amount > 1000),
employee_salary_end_date date null,
CONSTRAINT employee_salary_pk primary key (employee_id,
employee_salary_start_date),
constraint employee_id_fk1 foreign key (employee_id) REFERENCES
employee (employee_id));```{{execute}}

```\d employee_salary_hist```{{execute}}

- `employee_id` is of data type INTEGER and not null constraint.
- `employee_salary_start_date` is of data type DATE and not null constraint.
- `employee_salary_amount` is of data type NUMERIC of length 13 and capture 2 digits after the decimal point.
- `employee_salary_end_date` is of data type DATE and null constraint.

Constraints:

- `employee_salary_pk` is a composite Primary Key constraint of two fields `employee_id` and `employee_salary_start_date`. PostgreSQL automatically creates a unique index when a primary key is defined for a table. You can see `"employee_salary_pk " PRIMARY KEY, btree (employee_id, employee_salary_start_date)` under Indexes.
- The `employee_id_fk1` foreign key constraint in this table references the Employee (`employee_id`) table.
- A CHECK constraint is added to make sure salary > 1000.

Now that we have created all the tables, let's move forward further understand how all constraints work by inserting data in tables.
