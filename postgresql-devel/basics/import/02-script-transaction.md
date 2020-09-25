Let's try a script that has an error:

```
psql -U groot -h localhost -d workshop -f /data/test_create_and_insert.sql
```{{execute}}

You should be getting an error message `ERROR:  VALUES lists must all be the same length`,
 indicating where in the file the error occurs (line 12, from `/data/test_create_and_insert.sql:12`).

If you try running the statement above another time, this time you should get 
 an additional error: `relation "new_test_table" already exists`. Let's take a 
quick look at the contents of the file, since it's a very short script:

```
less /data/test_create_and_insert.sql
```{{execute}}

The CREATE TABLE statement was actually executed successfully the first time 
you ran the script. CREATE statements, like INSERT, are also treated as 
transactions. Even if the INSERT statement failed, the CREATE statement is an 
independent transaction so you can still consider the script as "completed" 
even if these statements were executed within a single `psql` command.

With this in mind, there are some [`psql` command-line options](https://www.postgresql.org/docs/current/app-psql.html)
 that you might consider using when feeding in a script:

- `-b` / `--echo-errors`: print failed SQL commands to standard error output
- `-1` / `--single-transaction`: wrap all commands in a single transaction, 
which means that either all commands complete successfully, or no changes are 
applied.

Let's log back into Postgres:

```
psql -U groot -h localhost workshop
```{{execute}}

We should see that `new_test_table` was indeed created from the script, but it 
contains no rows. 

```
SELECT * FROM new_test_table;
```{{execute}}

When the multi-row insert is aborted, no values get added to the table (even if
the errant row comes last!).
