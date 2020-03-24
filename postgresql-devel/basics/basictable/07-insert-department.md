


Let's take a look at how indentity columns work. The `department_number` column in the Department table has the GENERATED AS IDENTITY constraint, which means PostgreSQL generates a value for the identity column.

```
INSERT INTO department ( department_name)
values ('SALES'),
('PAYROLL'),
('RESEARCH'),
('MARKETING'),
('GRAPHICS');

SELECT * from department;
```{{execute}}

Let's insert a row manually and review the data. Identity behaves in the same way as the serial type.

```
INSERT INTO department ( department_number,department_name)
values (6, 'APPLICATION DEVELOPMENT');
SELECT * from department;
```{{execute}}

This insert will error out here since the value of the identity is not also manually specified, so it ends up duplicating an existing identity value:

```
INSERT INTO department ( department_name)
values ('OPERATIONS');
```{{execute}}

Let's try the insert without the `department_number` again and see if identity value auto increments:

```
INSERT INTO department ( department_name)
values ('ACCOUNTING');
```{{execute}}

Let's review the data currently in the Department table:

```select * from department;```{{execute}}

To see how uniqueness for `department_name` works. Let's try to insert an 'Accounting' row:

```
INSERT INTO department ( department_name)
values ('ACCOUNTING');
```{{execute}}

The message `ERROR: duplicate key value violates unique constraint "department_ak" DETAIL: Key (department_name)=(ACCOUNTING) already exists` displays.

Let's move forward.
