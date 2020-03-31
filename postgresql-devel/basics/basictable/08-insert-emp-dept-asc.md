

According to the business scenario, John works in Sales, Mary works in Research, and Arnold and Jeffery work in Accounting.

The Employee Department Association table has foreign key references to the Employee and Department tables. This implies that we cannot insert a row into the employee_department_asc table without referencing a valid employee_id in the Employee table and a valid department_number in the Department table.

The insert statement below uses a SELECT statement to associate department_number and employee_id based on employee_first_name, employee_last_name and department_name.

```
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
```{{execute}}

Let’s check the data in the table and make sure it looks good. We'll do so by joining the employee, department and employe_department_asc table.

```
SELECT employee.employee_id,employee_department_asc.department_number, department_name,
employee_ssn, employee_first_name, employee_last_name,employee_hire_date, employee_termination_datetime
FROM employee inner join employee_department_asc on
employee.employee_id =employee_department_asc.employee_id
inner join department on employee_department_asc.department_number =department.department_number;
```{{execute}}

Let's try to insert some data where the employee does not exist in the Employee table.

```
INSERT INTO employee_department_asc( employee_id, department_number, employee_department_start_date) 
VALUES (10,7,current_date);
```{{execute}}

You'll see the error message `"ERROR: insert or update on table "employee_department_asc" violates foreign key constraint "employee_id_fk" DETAIL: Key (employee_id)=(10) is not present in table "employee".`

Let's move forward.
