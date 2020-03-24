

Following the data model, we'll create an Employee table. Remember, to create a new table in PostgreSQL, you use the `CREATE TABLE` statement, and define the table name, field name(s), field data type(s), and constraints.

Once we create the table, we will review how Postgres describes the table structure, column data types and constraints.

```
CREATE TABLE employee(
employee_id serial CONSTRAINT employee_id_pk PRIMARY KEY,
employee_ssn VARCHAR (10) constraint employee_ak UNIQUE NOT NULL,
employee_first_name CHAR (35) NOT NULL,
employee_last_name CHAR (50) NOT NULL,
employee_hire_date date NOT NULL,
employee_termination_datetime timestamp with time zone
);
```{{execute}}

Let’s check the table definition using the `\d` psql command. This command tells Postgres to display the table definition.

```\d employee```{{execute}}

Let's go through the columns, data types, and other information for each field:

- `employee_id`
    - This field is of data type `SERIAL` (Integer). Serial is technically not a "true" data type but simply shorthand notation that tells Postgres to create a unique identifier for the specified column of type Integer, auto increment by 1. You'll see that the Default column in the table definition contains `nextval('employee_employee_id_seq'::regclass)` for this field.
    - We also created a PRIMARY KEY constraint named `employee_id_pk`. The primary key constraint is a combination of NOT NULL (i.e. must contain a value) and UNIQUE constraints. A primary key constraint indicates that a column, or group of columns, can be used as a unique identifier for rows in the table.
    - Postgres automatically creates a unique index when a unique constraint or primary key is defined for a table. You'll see `"employee_id_pk" PRIMARY KEY, btree (employee_id)` in the Indexes section.
- `employee_ssn`
    - This field is of data type character varying(n) - `varchar`, where **n** is a positive integer. In this example, we have specified a variable length with a limit of 10 characters.
    - We created a unique constraint named `employee_ak` and specified not null. Postgres enforces uniqueness using a unique index when a unique constraint is defined for a table. `"employee_ak" UNIQUE CONSTRAINT, btree (employee_ssn)` is included in the Indexes section as well.
- `employee_first_name` and `employee_last_name`
    - These fields have a data type `char`: character (n), where n is a positive integer. In this example, the fields have a fixed length of 35 and 50 respectively. If the string to be stored is shorter than the declared length, `char` values will be space-padded; `varchar` will simply store the shorter string. `char` values are padded with spaces to the specified width **n** and are stored and displayed that way. However, trailing spaces are treated as semantically insignificant and disregarded when comparing two values of type `char`.
    - NOT NULL constraints have been added, so these fields must have values.
- `employee_hire_date`
    - This field has a data type `date` (no time of day), which takes 4 bytes to store a date value.
    - There is a NOT NULL constraint, so a value is required.
- `employee_termination_date`
    - This field has a data type `timestamp` which stores both date and time (time zone) using up 8 bytes. For `timestamp with time zone`, the internally stored value is always in UTC (Universal Coordinated Time, traditionally known as Greenwich Mean Time, GMT). An input value that has an explicit time zone specified is converted to UTC using the appropriate offset for that time zone. If no time zone is stated in the input string, then it is assumed to be in the time zone indicated by the system’s TimeZone parameter and is converted to UTC using the offset for the timezone zone.
    - Since this is nullable column, values in this field are not required.
