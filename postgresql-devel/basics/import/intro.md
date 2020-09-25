There are a number of ways to add data to PostgreSQL. If you've completed the 
other scenarios in this course, you've already used the `INSERT` command to add
 one or more rows to a database table. In this scenario, we'll take that a step
 further by trying these methods of loading data in Postgres:

1. Executing a SQL script via the command line using `psql`
2. Using the `\copy` meta-command to bulk import from a data file

The data file we'll use is from the [Museum of Modern Art (New York City)](https://www.moma.org/)'s 
[collection data](https://github.com/MuseumofModernArt/collection/releases/tag/v1.58) which they have made available to the public domain.

This scenario will not cover all of the details of scripting or bulk imports; 
nor will we be able to tackle all the possible ways to load data in Postgres. 
That said, towards the end we'll take a brief look at the Import tool in 
[pgAdmin4](https://www.pgadmin.org/) as well as other utilities.

Since we'll be doing work in this scenario mainly with the `psql` utility, it 
may help to complete our [Intro to `psql` class](https://learn.crunchydata.com/postgresql-devel/courses/basics/) 
first if you haven't already done so.
