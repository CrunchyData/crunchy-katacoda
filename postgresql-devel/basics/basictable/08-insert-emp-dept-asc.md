Let insert data in employee_department_asc, according to requirement John works in Sales, Mary works in Research and Arnold and Jeffery
work in Accounting.

```postgresql
INSERT INTO employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM employee where
employee_first_name ='John' and employee_last_name = 'Smith'),
(SELECT department_number FROM department where department_name
= 'SALES'),current_date);

INSERT INTO employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM employee where
employee_first_name ='Mary' and employee_last_name = 'Smith'),
(SELECT department_number FROM department where department_name
= 'RESEARCH'),current_date);

INSERT INTO employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM employee where
employee_first_name ='Arnold' and employee_last_name = 'Jackson'),
(SELECT department_number FROM department where department_name
= 'ACCOUNTING'),current_date);

INSERT INTO employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM employee where
employee_first_name ='Jeffery' and employee_last_name = 'Westman'),
(SELECT department_number FROM department where department_name
= 'ACCOUNTING'),current_date);
``` {{execute}}

Let’s check data in the table and make sure data looks good, by joining
emmploye , department and employe_department_asc table.

```postgresql
SELECT employee.employee_id,employee_department_asc.department_number, department_name,
employee_ssn, employee_first_name, employee_last_name,employee_hire_date, employee_termination_datetime
FROM employee inner join employee_department_asc on
employee.employee_id =employee_department_asc.employee_id
inner join department on employee_department_asc.department_number =department.department_number;

``` {{execute}}

Let's move forward.
