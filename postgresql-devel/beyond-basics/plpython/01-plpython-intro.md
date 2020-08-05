
You saw in the [Basic Functions for Developers](https://learn.crunchydata.com/postgresql-devel/courses/beyond-basics/basicfunctions)
 scenario that you can use a variety of programming languages 
 to add even more functionality to PostgreSQL. This comes in handy if you 
happen to be already familiar with one of these languages. 

Python is one of the most popular programming languages and is also 
[supported in core PostgreSQL](https://www.postgresql.org/docs/current/external-pl.html).
 In this scenario, we'll learn how to enable PL/Python and get started with 
 creating some simple user-defined functions.

With that said, just because the base distribution of Postgres already comes 
with Python support, doesn't mean Postgres also includes Python itself. You'll 
need to make sure Python is installed on the same machine as well. 

>_What about different Python versions?_  
Postgres supports [both Python 2 and Python 3](https://www.postgresql.org/docs/current/plpython-python23.html). The current "default" is Python 2. 

## Enable PL/Python

In this environment, we already have Python 3 installed. To enable PL/Python in
 Postgres, we first need a superuser role to load the extension in the database
  we're working in.

`psql -U postgres -h localhost workshop`{{execute}}

(The password is `password`, same as the user `groot`.)

`CREATE EXTENSION plpython3u;`{{execute}}

PL/Python is only available as an [untrusted language](https://www.postgresql.org/docs/current/plpython.html). As you may have also seen in the [PL/R in PostgreSQL](https://learn.crunchydata.com/postgresql-devel/courses/beyond-basics/qplr/) scenario, the language can be updated to make it trusted, like so:

```
UPDATE pg_language SET lanpltrusted = true WHERE lanname LIKE 'plpython3u';
```{{execute}}

We also want to emphasize here that Python, like many of the procedural 
languages supported in Postgres, can interact with the underlying operating 
system. So, as also mentioned in the PL/R scenario, our proposed 
workflow for development is:

1. Allow PL/Python to be a trusted language **only in the development environment**.
2. Developers can create, iterate, and test PL/Python functions in their dev 
environment.
3. When ready, someone with superuser privileges can transfer the function 
into production.
