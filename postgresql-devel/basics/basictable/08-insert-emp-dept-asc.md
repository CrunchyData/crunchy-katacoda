Let insert data in employee_department_asc, according to requirement John works in Sales, Mary works in Research and Arnold and Jeffery
work in Accounting. 

This table has foreign key reference to Employee and depatment table. We cannot insert a row into the employee_department_asc without referencing to a valid employee_id in the Employee table and a valid department_number in Department table.

Below insert statement is using select statement to associate department_number and employee_id based on the employee_first_name, employee_last_name and department_name.

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

Let’s check data in the table and make sure data looks good, by joining emmploye, department and employe_department_asc table.

```postgresql
SELECT employee.employee_id,employee_department_asc.department_number, department_name,
employee_ssn, employee_first_name, employee_last_name,employee_hire_date, employee_termination_datetime
FROM employee inner join employee_department_asc on
employee.employee_id =employee_department_asc.employee_id
inner join department on employee_department_asc.department_number =department.department_number;

``` {{execute}}

Let's try to insert data where employee does not exist in the employee table. 

```postgresql
INSERT INTO employee_department_asc( employee_id, department_number, employee_department_start_date) 
VALUES (10,7,current_date);
``` {{execute}}

You will get error message "ERROR:  insert or update on table "employee_department_asc" violates foreign key constraint "employee_id_fk"
DETAIL:  Key (employee_id)=(10) is not present in table "employee"."

Let's move forward.
