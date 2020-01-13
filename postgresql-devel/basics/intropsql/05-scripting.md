## Scripting

Getting more comfortable with the command line and `psql` allows you to expedite and automate tasks.

One simple example is to use a SQL script to quickly create a new table and add some values
to it. Again, while you could also run SQL scripts with tools like pgAdmin, the command line
lets you do so with just a few keystrokes.

We've included a file `test_create_and_copy.sql` in the interactive environment that does the following when run:

1. Create a new table `cp_se_details` with the same table structure as `se_details`,
and copy only data from the month of June.
2. Create a new table `new_test_table` and populate it with a few values.
3. Display the contents of `new_test_table`.

In the `psql` shell, we can use the `\i` command to run the contents of the file:

```
\i test_create_and_copy.sql
```{{execute}}

The result of the `SELECT` statement in the file shows that `new_test_table` was actually created and contains data, but for good measure, let's use `\d+` to see changes made on the database level:

`\d+`{{execute}}

In addition to `new_test_table`, you should also be seeing the `cp_se_details` table.

You don't even need to be in the `psql` shell to execute from a file. Let's say we were working outside of the `psql` shell, doing some other work on the command line:

`\q`{{execute}}

We want to check the contents of the script first. We can use the `cat` command (UNIX and Linux) to
read the contents of the file and display them as output in the terminal.

```
cat test_create_and_copy.sql
```{{execute}}

If we're happy with what we see, we can then run `psql` to execute the SQL in this file. Note that the following command will execute the contents of the file, and then exit (per `psql --help`). (We won't run it this time, since you'll encounter errors trying to create the same tables from running `\i+` above.)

```
psql -h localhost -U groot -d workshop -f test_create_and_copy.sql
```

> **Note**
> 
> We won't cover this in the course, but `psql` can also be used in shell scripts so that you can combine `psql` with other commands. This means that you can do a lot of work (including a series of complex tasks) in an efficient way.
