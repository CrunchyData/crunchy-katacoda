## Looking back at inserts

An INSERT statement in Postgres is transactional, meaning that each one is 
considered as a single unit of work. Running a few inserts is fine if you 
just want some rows data for testing, but once you need more than that you'll 
see the impact in:

- Performance - each write operation has to be completed before the server can 
proceed to the next.
- Your productivity - it's not a great use of your time to write so many INSERT 
statements especially if you or someone else needs to carry out this work more 
than once. 

In terms of productivity, you might already be thinking: "Well, can't I write 
a script to help me out?" Absolutely! If you know basic SQL or you've done the 
other scenarios in this course, you should be able to put together at least a 
basic script. Additionally, you could try a utility such as [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) 
which can extract (i.e. back up) a database into a "dump" script.

In this section we'll take a simple script and see how easy it is to run it 
with the [psql](https://www.postgresql.org/docs/current/app-psql.html) tool. 
This script also takes advantage of multi-row inserts, which are more 
performant than running multiple individual inserts. There are plenty of 
options to speed up data loads into Postgres.

## Load data from the command line

In this environment, we've uploaded an `employees.sql` file that actually 
recreates some of the database schema from our [Create Table](https://learn.crunchydata.com/postgresql-devel/courses/basics/basictable) and [Basic Data Types](https://learn.crunchydata.com/postgresql-devel/courses/basics/basicdatatype) scenarios.

First, let's log in to Postgres as user `groot`, and look at what's currently 
in our `workshop` database (password: `password`):

```
psql -U groot -h localhost -d workshop -c '\dt'
```{{execute}}

So far there are two tables... Nothing that looks related to employees.

Let's take a look at the contents of the `employees.sql` script:

```sh
less /data/employees.sql
```{{execute}}
(Press the spacebar to scroll to the next page, or `q` to return to the command
prompt.)

We're creating four new tables and adding just a handful of data rows to each.

Now, let's use the `-f` flag in `psql` to run the script and add these new 
objects to the `workshop` database:

```
psql -U groot -h localhost -d workshop -f /data/employees.sql
```{{execute}}

The `-f` flag takes in a filename or path as argument, and the `psql` client 
will read commands contained in that file. You should see which commands were 
completed, although running `psql` with this flag does not log you in to 
Postgres so you're still on the shell prompt.

Let's actually log back in and take a look at `workshop` again:

```
psql -U groot -h localhost -d workshop
```{{execute}}
```
\dt
```{{execute}}
You should now see the four additional tables. And if we run:

```
SELECT * FROM department;
```{{execute}}
We see the entire contents of this table.

>**Note: psql `\i` meta-command**
>  
>If you're in the psql shell, you can also execute a script like so:  
>`\i /data/employees.sql`

### Try an advanced example with our pg_dump and pg_restore class

The example we tried above was a basic demonstration of feeding a script into 
the `psql` tool to get some data into Postgres. 

You may encounter situations in which you need to export and import a database--for example, to restore a backup for data recovery. As mentioned above, 
 pg_dump can generate plaintext script files which can also be used with 
`psql`. pg_dump can export the database in other file formats as well, for which 
you'll need [pg_restore](https://www.postgresql.org/docs/12/app-pgrestore.html).
 To learn more about pg_dump and pg_restore, check out the [intro course](https://learn.crunchydata.com/pg-administration/courses/basic-postgresql-for-dbas-12/dump-restore/) available in our learning portal.
