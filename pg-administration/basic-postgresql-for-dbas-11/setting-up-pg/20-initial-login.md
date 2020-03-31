
By default a `postgres` system user is created for you by the packages that were installed. Let's change to that user. We're going to do so in the second terminal named "`postgres_terminal`" and from now on, any commands that need to be run by the `postgres` system user will be run from this terminal. Any other system commands prepended with a `sudo` will be run from the intial terminal. 
```
sudo -iu postgres
```{{execute T2}}

Then, log into the database
```
psql
```{{execute T2}}

The `psql` command line is an extremely powerful tool for interacting with PostgreSQL. The full list of commands is always available by typing `\?` or by referring to the documentation - https://www.postgresql.org/docs/current/app-psql.html

Probably one of the most important initial commands to know via psql is to see where the data directory for the database you're currently logged into is located. The current value for any setting in PostgreSQL can be seen by using the `SHOW` command. So let's check the `data_directory` setting.
```
SHOW data_directory;
```{{execute T2}}







