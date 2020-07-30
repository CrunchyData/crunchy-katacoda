

Install pl/python

`psql -U postgres -h localhost workshop`{{execute}}

`CREATE EXTENSION plpython3u;`{{execute}}

Make PL/Python trusted

`UPDATE pg_language SET lanpltrusted = true WHERE lanname LIKE 'plpython3u';`{{execute}}

Log out and log in as groot

`psql -U groot -h localhost workshop`{{execute}}

Create a new function

```sql
CREATE OR REPLACE FUNCTION two_power_three ()
RETURNS VARCHAR
AS $$
    result = 2**3
    return f'Hello! 2 to the power of 3 is {result}.'
$$ LANGUAGE 'plpython3u';

```{{execute}}

Call the function

`SELECT two_power_three ()`{{execute}}

Include some of the content below:



## Stored Procedures and Functions in R

Stored procedures and functions allow you to write code, embed it into the database, and then be called the same as other normal
database functions. A stored procedure is the same as a stored function except the procedure does not return anything.

There are [many languages](https://www.postgresql.org/docs/11/external-pl.html) you can use to write a stored function in Postgresql, 
but today we will be working with R. If you go look at that list you will notice many of those languages can interact with 
the Operating System. That is why, in general, most languages are treated as **untrusted**. Since stored functions execute with 
the OS privileges of the Postgres user - you don't want just anyone writing stored functions unless they are using a trusted 
language.  

#### What this means for development.

Our proposed workflow for development, which will we do below, is to allow the language to be trusted **only** in the development 
environment. In this way developers can make their own functions, iterate them, and get them working correctly. Then
, when it's 
time to go to production, someone with DB superuser privileges can transfer the function to the production database
. This will involve
tracking changes to function and having a migration procedure but the extra work is well worth it given the alternative. 

Again - make the language trusted in your development environment **NOT** your production environment.

Here is the overview documentation on [stored functions](https://www.postgresql.org/docs/11/xfunc.html) and here is the 
reference doc on how to create a [stored function](https://www.postgresql.org/docs/11/sql-createfunction.html) 
or a [stored procedure](https://www.postgresql.org/docs/11/sql-createprocedure.html).

#### Putting R in PostgreSQL
We already installed the R language (PL/R) into PostgreSQL for you, so let's get started.

First we need to make PL/R a trusted language - this has to be done as the postgres user:

`psql -U postgres -h localhost workshop`{{execute}}


The password will be "password" just like the user groot.

Now update the language status:


`UPDATE pg_language SET lanpltrusted = true WHERE lanname LIKE 'plr';`{{execute}}

Now logout:

`\q`{{execute}}

Changing the language status only has to happen once in the lifetime of the database. 

Now log back in as normal user groot. 

`psql -U groot -h localhost workshop`{{execute}}


and then enter the following command:

```sql
CREATE OR REPLACE FUNCTION two_times_two()
RETURNS INTEGER as $$
    result <- 2*2
    return(result)
$$ LANGUAGE 'plr';

```{{execute}}

1. We name our function *two_times_two*
1. We are not accepting any input, hence the () 
1. We are going to return an integer
1. Everything between the set of $$s is the actual function
1. We declare that the function uses the language extension PL/R.

and now let's call our highly technical new function:

` select two_times_two();`{{execute}}

### Wrap up 
Ok now that we have R working as a language in PostgreSQL let's do more interesting things!
