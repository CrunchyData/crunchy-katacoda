# Create and Insert Employee Department Association table

Let's create employee department association table, to create a new table in PostgreSQL, you use the CREATE TABLE statement, table name and field name, field datatype and constriants. Once we create the table we will review the table structure.

```postgresql
Create table employee_department_asc (
employee_id integer not null,
department_number integer not null,
employee_department_start_date date not null,
employee_department_end_date date null,
CONSTRAINT employee_department_pk primary key (employee_id,
department_number),
constraint employee_id_fk foreign key (employee_id) REFERENCES
employee (employee_id),
constraint department_number_fk foreign key (department_number)
REFERENCES department (department_number) );

create index department_number_idx on employee_department_asc
(department_number );
``` {{execute}}

Let's review the table structure 
```postgresql
\d employee_department_asc
``` {{execute}}

  - employee_id is of data type integer and not null constraint.
  - department_number is of data type integer and not null constraint.
  - employee_department_start_date is of data type date and not null
    constraint.
  - employee_department_end_date is of data type date and null
    constraint.
  - Constraints
      - employee_department_pk is a composite primary Key constraint
        with 2 fields employee_id and department_number. PostgreSQL
        automatically creates a unique index when a unique constraint or
        primary key is defined for a table. You can see
        "employee_department_pk" PRIMARY KEY, btree (employee_id,
        department_number)
      - employee_id_fk foreign key constraint in this table that
        references the employee (employee_id), table. A foreign key
        constraint specifies that the values in a column (or a group of
        columns) must match the values appearing in some row of another
        table. We say this maintains the referential integrity between
        two related tables.
      - department_number_fk foreign key constraint in this table that
        references the department (department_number) table. Please
        note Postgres does not create foreign key index automatically as
        it does for primary key. So we created an index using create
        index. You can see "department_number_idx" btree
        (department_number)

Let insert data in employee_department_asc, according to requirement John works in Sales, Mary works in Research and Arnold and Jeffery
work in Accounting.

```postgresql
INSERT INTO public.employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM public.employee where
employee_first_name ='John' and employee_last_name = 'Smith'),
(SELECT department_number FROM public.department where department_name
= 'SALES'),current_date);

INSERT INTO public.employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM public.employee where
employee_first_name ='Mary' and employee_last_name = 'Smith'),
(SELECT department_number FROM public.department where department_name
= 'RESEARCH'),current_date);

INSERT INTO public.employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM public.employee where
employee_first_name ='Arnold' and employee_last_name = 'Jackson'),
(SELECT department_number FROM public.department where department_name
= 'ACCOUNTING'),current_date);

INSERT INTO public.employee_department_asc(
employee_id, department_number, employee_department_start_date)
VALUES ((select employee_id FROM public.employee where
employee_first_name ='Jeffery' and employee_last_name = 'Westman'),
(SELECT department_number FROM public.department where department_name
= 'ACCOUNTING'),current_date);
``` {{execute}}

Let’s check data in the table and make sure data looks good, by joining
emmploye , department and employe_department_asc table.

```postgresql
SELECT employee.employee_id,employee_department_asc.department_number, department_name,
employee_ssn, employee_first_name, employee_last_name,employee_hire_date, employee_termination_datetime
FROM public.employee inner join public.employee_department_asc on
employee.employee_id =employee_department_asc.employee_id
inner join public.department on employee_department_asc.department_number =department.department_number;

``` {{execute}}

I hope you are understanding the flow so let's move on.
