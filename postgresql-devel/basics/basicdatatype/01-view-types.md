## So what about data types?

Take Excel: when you create a new spreadsheet, you're starting completely from
scratch. You don't even have to worry about data types as you begin adding
values to the spreadsheet (Excel might make educated guesses). However, once
you need to do any type of calculation, function, or processing, formatting
the cells or columns to the correct data type becomes necessary.

PostgreSQL and other relational database management systems work a little bit 
differently in that when you create a new table, you must specify the data 
type associated with each column. You _can_ change the data type at a later 
time (towards the end of this course we'll see how to do so, and consider its 
implications), but the data type must be set initially each time a new table is
 created or a new column added to a table.

### Check data types in a table

It's good practice to take a glance around whenever you start working with a database that's new to you. You'll have a better idea of how to work with the data, and it 
helps with troubleshooting issues later.

In the terminal, you can quickly check data types in a table by logging in to 
Postgres using `psql`:

`psql -U groot -h localhost workshop`

You'll be prompted for the password (enter `password`).

Once logged in, run this `psql` command to see the table definition for the `employee` table:

```
\d employee
```{{execute}}

You should see metadata for the `groot.employee` table where Type indicates the
 data type held in that column. 

And if you display the contents of the table, you should see data in each 
column that matches up with the designated data type:

```
SELECT * FROM employee;
```{{execute}}

(Since this is a small table, a `SELECT *` is fine, but it might make more 
sense to use [`LIMIT`](https://www.postgresql.org/docs/current/queries-limit.html) for any potentially large tables.)

Postgres currently has over 40 built-in data types. There is also the ability 
to create user-defined data types, which will not be discussed in this intro course.
