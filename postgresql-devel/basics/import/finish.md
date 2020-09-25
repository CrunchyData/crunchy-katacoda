We've looked at a few different ways of loading data into a PostgreSQL database.
 Data can be added in bulk via a script, the copy utility (either the `\copy` 
 meta-command in `psql`, or the SQL `COPY` command), or a client like pgAdmin.

These are certainly not the only methods of loading data into Postgres - there 
are many others that might be suitable depending on your requirements. For example, foreign data wrappers (such as [`postgres_fdw`](https://www.postgresql.org/docs/current/postgres-fdw.html)) allow access to external databases, from which you could then import to your own. There are [many types of foreign data wrappers](https://wiki.postgresql.org/wiki/Foreign_data_wrappers) that give you access to other kinds of DBMS's such as MySQL, SQL Server, and MongoDB.

[pgloader](https://pgloader.io/) is an example of a data migration tool that 
supports database migrations to PostgreSQL from other DBMS's like MySQL, as 
well as file formats other than flat files such as CSV.  

