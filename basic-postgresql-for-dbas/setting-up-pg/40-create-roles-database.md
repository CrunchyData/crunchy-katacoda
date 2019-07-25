
As we discussed in the previous step, the default setup for the cluster provided by EL7 based systems is to allow peer based authentication. Back in our root user terminal, let's see what happens if we try and log into the database using just the `psql` command with no additional options.
```
clear
psql
```{{execute T1}}
The error that returns shows that if you do not tell psql which role you want to log in as (using the `-U` option), psql will default to trying to log in as a role that matches the current system user. In this case `root`.

So let's create a root role in our `postgres_terminal` where we can log in
```
CREATE ROLE root WITH LOGIN SUPERUSER;
```{{execute T2}}
We've added two properties onto this role.

`LOGIN` is required if you want this role to be able to log in. And we're also just going to make this role a SUPERUSER as well so we can continue using it without having to switch back to the `postgres_terminal` all the time to run SQL commands.

Now lets see what happens if we try and log in as root again with no options
```
psql
```{{execute T1}}
Now we're getting an error about a `root` database not existing. So if we don't provide a database name (using the `-d` option), psql will try and log in to a database name that matches the current system user. 
```
psql -d postgres
\q
```{{execute T1}}
The `peer` authentication method only checks for the role name to match, so we can give another database name and log in that way. But to make it even easier, let's create a new database back on the `postgres_terminal`
```
CREATE DATABASE root;
```{{execute T2}}
Let's try one last time back on our root terminal with no options
```
psql
```{{execute T1}}
And it works! We're now taking advantage of the `peer` authentication method to log into the database without a password.

We can also set the password for our own role (or other roles if you're a superuser) using the `\password` command. It is recommended to use this method vs setting the password during role creation or using the ALTER ROLE command since this keeps the password from getting put in the clear into the history buffer or the logs.

This step was given in this manner since this is an often seen issue when people are first setting up PostgreSQL and cannot figure out why they can't log in as their normal system user. Going through this process hopefully helps you better understand how psql works in any environment.


