


The salary history table has a foreign key reference to the Employee table. This implies that we cannot insert a row into employee_salary_hist without referencing a valid employee_id in the Employee table, and the salary amount must be greater than 1000.

```
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
```{{execute}}

Let's try to insert a row with salary of 100 dollars:

```
INSERT INTO employee_salary_hist(
    employee_id, employee_salary_start_date, employee_salary_amount, employee_salary_end_date)
select 6, '2016-03-01'::date , 100.00, '2017-02-28'::date ;
```{{execute}}

The error message `ERROR: new row for relation "employee_salary_hist" violates check constraint "salary_ck1"` indicates that the new row did not meet the check criteria.

Let's try to insert an employee_id that does not exist in the employee table.

```
INSERT INTO employee_salary_hist(
    employee_id, employee_salary_start_date, employee_salary_amount, employee_salary_end_date)
select 10, '2016-03-01'::date , 10000.00, '2017-02-28'::date ;
```{{execute}}
This results in the following error message: `"ERROR: insert or update on table "employee_salary_hist" violates foreign key constraint "employee_id_fk1"`

Let's summarize what we learned.
