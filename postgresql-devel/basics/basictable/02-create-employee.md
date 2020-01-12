# Create Employee table

Let's create Employee table, to create a new table in PostgreSQL, you use the CREATE TABLE statement, table name and field name, field datatype and constriants. Once we create the table we will review how Postgres describes the table structure.


```postgresql
CREATE TABLE employee(
employee_id serial CONSTRAINT employee_id_pk PRIMARY KEY,
employee_ssn VARCHAR (10) constraint employee_ak UNIQUE NOT NULL,
employee_first_name CHAR (35) NOT NULL,
employee_last_name CHAR (50) NOT NULL,
employee_hire_date date NOT NULL,
employee_termination_datetime timestamp with time zone
);

```
{{execute}}

Let’s check the table definition, \d in psql means telling postgres to display table definition.

```postgresql
\d employee
``` 
{{execute}}


Please note we have not given any schema name, if the schema name is not given generally table will be created in public
schema.

Let's review the columns, data type and other information for each field.

  - Employee_id
    
      - is of datatype SERIAL (Integer). Serial is not a true data type
        but is simply shorthand notation that tells Postgres to create
        an auto incremented, unique identifier for the specified column
        of type Integer and it autoincrements by 1. You can see
        nextval('employee_employee_id_seq'::regclass)    
      - Created a Primary Key constraint of name employee_id_pk, this
        constraint is the combination of NOT NULL (must contain a value) and UNIQUE constraint.
        A primary key constraint indicates that a column, or group of
        columns, can be used as a unique identifier for rows in the
        table. This requires that the values be both unique and not
        null.
    
      - PostgreSQL automatically creates a unique index when a unique
        constraint or primary key is defined for a table. You can see
        "employee_id_pk" PRIMARY KEY, btree (employee_id)

  - employee_ssn
    
      - is of data type character varying(n), where n is a positive
        integer, in this case defined to be 10.
    
      - Created a unique constraint of name employee_ak and not null.
        Here again PostgreSQL automatically creates a unique index when
        a unique constraint is defined for a table. You can see
        "employee_ak" UNIQUE CONSTRAINT, btree (employee_ssn) as well.

  - employee_first_name and employee_last_name
    
      - is of data type character (n), where n is a positive integer, in
        this case defined to be 35 and 50 respectively. If the string to
        be stored is shorter than the declared length, values of type
        character will be space-padded; values of type character varying
        will simply store the shorter string. Values of type character
        are physically padded with spaces to the specified width n and
        are stored and displayed that way. However, trailing spaces are
        treated as semantically insignificant and disregarded when
        comparing two values of type character.
    
      - Not null constraint.

  - employee_hire_date
    
      - is of data type date (no time of day) of 4 bytes
    
      - Not null constraint.

  - employee_termination_date
    
      - is of data type timestamp both date and time (time zone) of 8
        bytes. For timestamp with time zone, the internally stored value
        is always in UTC (Universal Coordinated Time, traditionally
        known as Greenwich Mean Time, GMT). An input value that has an
        explicit time zone specified is converted to UTC using the
        appropriate offset for that time zone. If no time zone is stated
        in the input string, then it is assumed to be in the time zone
        indicated by the system’s TimeZone parameter and is converted to
        UTC using the offset for the timezone zone.
    
      - This is nullable column

