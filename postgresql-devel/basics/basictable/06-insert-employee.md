


Let's insert data into the Employee table according to business scenario and understand how serial columns work and uniqueness is enforced.

Per business requirments, we need to insert John Smith, Mary Smith, Arnold Jackson, and Jeffery Westman (`hire_date` is today. `current_date` is a PostgreSQL funtion that returns the current date on the system.

```
INSERT INTO employee( employee_ssn, employee_first_name,employee_last_name, employee_hire_date)
VALUES ( '111111111', 'John', 'Smith', current_date),
( '111111112', 'Mary', 'Smith', current_date),
( '111111113', 'Arnold', 'Jackson', current_date),
( '111111114', 'Jeffery', 'Westman', current_date);
```{{execute}}

Please note that the above INSERT statement does not have the `employee_id` field. Since `employee_id` has a SERIAL data type, PostgreSQL will populate it with auto-incremented integer values. 

Let’s review data from the Employee table:

```SELECT * FROM employee;```{{execute}}

You might be wondering: "Can we manually insert values into a serial column?" Let's give it a try:

```
INSERT INTO employee( employee_id, employee_ssn,
employee_first_name, employee_last_name, employee_hire_date)
VALUES ( 6, '111111115', 'Bob', 'Box', current_date);

-- review the data

SELECT * FROM employee;
```{{execute}}

We can see the value of 6 is successfully inserted. However, Postgres internally does not increment the sequence object associated with the serial. Let's continue inserting and see what might occur:

```
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111116', 'Best', 'CEO', current_date);

-- review the data 

SELECT * FROM employee;
```{{execute}}

Let's try one more:

```
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111117', 'Test', 'CFO', current_date);
```{{execute}}

You'll see that the row is not inserted, and the following  error message displays:
`'ERROR: duplicate key value violates unique constraint "employee_id_pk"'.`

Let's try the same insert again. This time, it is successful: even though the last insert failed, the sequence was still incremented automatically, so this id is stored as 7.

```
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111117', 'Test', 'CFO', current_date);

-- review the data

SELECT * FROM employee;
```{{execute}}

