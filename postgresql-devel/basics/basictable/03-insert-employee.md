# Insert Employee table

Let's insert data in employee table according to business scenario and understand how uniqueness serial columns work and uniqueness enforced. 

Let's insert John Smith, Mary Smith, Arnold Jackson and Jeffery Westman

```postgresql
INSERT INTO public.employee( employee_ssn, employee_first_name,employee_last_name, employee_hire_date)
VALUES ( '111111111', 'John', 'Smith', current_date),
VALUES ( '111111112', 'Mary', 'Smith', current_date),
VALUES ( '111111113', 'Arnold', 'Jackson', current_date),
VALUES ( '111111114', 'Jeffery', 'Westman', current_date);
``` 
{{execute}}

Please note above insert does not have employee_id field, then what values got assigned to employee_id field. Let’s review data from employee table.

```postgresql
SELECT * FROM public.employee;
``` 
{{execute}}

As you can see the employee_id fields have number values populated and auto incremented.

Now the question arises can we insert value
-- Below will insert successfully but does not set next val of sequence
to 7, this will cause sub

INSERT INTO public.employee( employee_id, employee_ssn,
employee_first_name, employee_last_name, employee_hire_date)

VALUES ( 6, '111111115', 'Bob', 'Box', current_date);

-- below value will be of 5

INSERT INTO public.employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)

VALUES ( '111111116', 'Best', 'CEO', current_date);

-- below will error out, because the sequence is at 6 and we manually
inserted employee_id of 6

INSERT INTO public.employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)

VALUES ( '111111117', 'Test', 'CFO', current_date);

-- let's insert again, this time it will be successful, sequence
incremented automatically even though insert failed, now the nextval of
the sequence is 7

INSERT INTO public.employee( employee_ssn, employee_first_name,
employee_last_name, employee_hire_date)

VALUES ( '111111117', 'Test', 'CFO', current_date);

Let’s select data from employee table

SELECT * FROM public.employee;
