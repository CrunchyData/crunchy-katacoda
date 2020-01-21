
Let’s insert data

```postgresql
INSERT INTO public.employee_salary_hist(
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
select 4, '2016-03-01'::date , 40000.00, null
``` {{execute}}


### Test Check Constraint ###

We will try to insert a row with salary of 100 dollars. 

``` INSERT INTO public.employee_salary_hist(
	employee_id, employee_salary_start_date, employee_salary_amount, employee_salary_end_date)
select 6, '2016-03-01'::date , 100.00, '2017-02-28'::date
``` {{execute}}
