We've seen the INSERT statement in earlier courses so we know by now that it 
is used to add new rows of data to a table.

In this course, we'll dive a little deeper into the nuances of INSERT. For 
example, what happens if you attempt to add a value that violates a constraint?
 We'll also try to place INSERT within the broader context of application 
 processing. 

INSERT is an example of what's referred to as Data Manipulation Language, since
 it allows you to add data to existing tables. UPDATE and DELETE are other 
types of DML statements. (CREATE TABLE, on the other hand, is considered Data 
Definition Language.)

In this scenario, we'll log you in to a database called `workshop` where a few 
tables have already been created and data has been loaded in. You'll be logged 
in as a user with all the necessary privileges to add new data to a table, as 
well as query existing tables. We'll also use the [command line](https://learn.crunchydata.com/postgresql-devel/courses/basics/intropsql) 
to interact with PostgreSQL.

We're structuring this course around the example of a career counseling agency 
we've called Extra Mile Counseling. If you did the [Advanced Data Types](https://learn.crunchydata.com/postgresql-devel/courses/basics/advdatatype)
 course, you'll be familiar with the example data model. Otherwise, if you'd 
like to get quickly caught up, feel free to run through that course before 
continuing with this one.
