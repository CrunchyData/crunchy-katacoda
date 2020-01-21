
Let’s insert data in department table and understand how indentity columns work. You can see it assigned auto incremented number to department_number.

```postgresql
insert into department ( department_name)
values ('SALES'),
('PAYROLL'),
('RESEARCH'),
('MARKETING'),
('GRAPHICS');

Select * from department;
``` {{execute}}

Let's insert value in department_value manually and review the data. Identity also behaves same way as Serial. 

```postgresql
insert into department ( department_number,department_name)
values (6, 'APPLICATION DEVELOPMENT');
Select * from department;
``` {{execute}}

Below insert will error again here the value of the identity was not set when we inserted row manually.

```postgresql
insert into department ( department_name)
values ('OPERATIONS');
``` {{execute}}

Let's insert without the department_number and see if department_number identity auto increments. 

```postgresql
insert into department ( department_name)
values ('ACCOUNTING');
``` {{execute}}



Let's review data in detpartment table.

```postgresql
select * from department;
``` {{execute}}

Let's see how uniqueness for department_name works.  Let's try inserting department Operations.

```postgresql
insert into department ( department_name)
values ('ACCOUNTING');
``` {{execute}}

You can see ERROR:  duplicate key value violates unique constraint "department_ak"
DETAIL:  Key (department_name)=(ACCOUNTING) already exists.

Let's move forward.
