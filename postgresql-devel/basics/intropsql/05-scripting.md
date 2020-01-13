## Scripting

Getting more comfortable with the command line and `psql` allows you to expedite and automate tasks.

One simple example is to use a SQL script to quickly create a new table and add some values
to it. Again, while you could also run SQL scripts with tools like pgAdmin, the command line
lets you do so with just a few keystrokes.

We've included a file `test_create_and_copy.sql` that does the following when run:

1. Create a new table `cp_se_details` with the same table structure as `se_details`,
and copy only data from the month of June.
2. Create a new table `new_test_table` and populate it with a few values.
3. Display the contents of `new_test_table`.

Let's say we were working outside of the `psql` shell, doing some other work on the command line:

`\q`{{execute}}

We want to check the contents of the script first. We can use the `cat` command (UNIX and Linux) to
read the contents of the file and display them as output in the terminal.

***THIS WON'T WORK***:
```
cat test_create_and_copy.sql
```{{execute}}

Then we can run `psql` to execute the SQL in this file.

```
psql -h localhost -U groot -d workshop -f test_create_and_copy.sql
```{{execute}}

We won't cover this in the course, but `psql` can also be used in shell scripts so that you can combine `psql` with other commands. This means that you can do a lot of work (including a series of complex tasks) in an efficient way.
