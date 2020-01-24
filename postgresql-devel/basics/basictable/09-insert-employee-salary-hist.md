
Let insert data in employee_salary_hist, according to requirement 

This table has foreign key reference to Employee table. We cannot insert a row into the employee_salary_hist without referencing to a valid employee_id in the Employee table and salary amount is > 1000.

Let’s insert data

```postgresql
INSERT INTO employee_salary_hist(
employee_id, employee_salary_start_date, employee_salary_amount,
employee_salary_end_date)
select 1, '2016-03-01'::date , 40000.00, '2017-02-28'::date
union
select 1, '2017-03-01'::date , 50000.00, null
union
select 2, '2016-03-01'::date , 40000.00, '2017-02-28'::date
union
select 2, '2016-04-01'::date , 40000.00, null
union
select 3, '2016-03-01'::date , 40000.00, null
union
select 4, '2016-03-01'::date , 40000.00, null;
``` {{execute}}

Let's try to insert a row with salary of 100 dollars. 

```postgresql
INSERT INTO employee_salary_hist(
	employee_id, employee_salary_start_date, employee_salary_amount, employee_salary_end_date)
select 6, '2016-03-01'::date , 100.00, '2017-02-28'::date ;
``` {{execute}}

You will get an error message "ERROR:  new row for relation "employee_salary_hist" violates check constraint "salary_ck1""

Let' try to insert employee_id that does not exist in employe table. 

```postgresql
INSERT INTO employee_salary_hist(
	employee_id, employee_salary_start_date, employee_salary_amount, employee_salary_end_date)
select 10, '2016-03-01'::date , 10000.00, '2017-02-28'::date ;
``` {{execute}}

You will get error message "ERROR:  insert or update on table "employee_salary_hist" violates foreign key constraint "employee_id_fk1"

Let's summarize what we learnt. 
