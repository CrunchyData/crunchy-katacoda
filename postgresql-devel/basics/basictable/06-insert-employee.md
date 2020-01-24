
Let's insert data in employee table according to business scenario and understand how serial columns work and uniqueness is enforced. 

Per business requirment we need to insert John Smith, Mary Smith, Arnold Jackson and Jeffery Westman, hire_date of today. Current_date is postgres funtion that returns current date on the system.

```postgresql
INSERT INTO employee( employee_ssn, employee_first_name,employee_last_name, employee_hire_date)
VALUES ( '111111111', 'John', 'Smith', current_date),
( '111111112', 'Mary', 'Smith', current_date),
( '111111113', 'Arnold', 'Jackson', current_date),
( '111111114', 'Jeffery', 'Westman', current_date);
``` {{execute}}

Please note above insert does not have employee_id field, since employee_id is defined PostgreSQL will populate it with integer values populated auto incremented.  Let’s review data from employee table.

```postgresql
SELECT * FROM employee;
``` {{execute}}

Now the question arises can we manually insert values in serial column. Let's try

```postgresql
INSERT INTO employee( employee_id, employee_ssn,
employee_first_name, employee_last_name, employee_hire_date)
VALUES ( 6, '111111115', 'Bob', 'Box', current_date);
-- review the data 
SELECT * FROM employee;
``` {{execute}}

We can see the value_id of 6 is inserted, if you insert the value manually PostgreSQL internally dose not increment sequence object assoicated to serial. Let's continue inserting and see when the error occurs. 

```postgresql
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111116', 'Best', 'CEO', current_date);
-- review the data 
SELECT * FROM employee;
``` {{execute}}

Let's insert and see if the error occurs because of the manual insert. 

```postgresql
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111117', 'Test', 'CFO', current_date);
``` {{execute}}

You can see the error message, "ERROR:  duplicate key value violates unique constraint "employee_id_pk" "

Let's insert again, this time it will be successful, sequence incremented automatically even though insert failed, now the nextval of
the sequence is 7

```postgresql
INSERT INTO employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)
VALUES ( '111111117', 'Test', 'CFO', current_date);
-- review the data 
SELECT * FROM employee;
``` {{execute}}

Let's continue.
