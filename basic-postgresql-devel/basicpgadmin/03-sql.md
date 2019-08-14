# Working with SQL in PgAdmin4

Now that we know how to get around in PgAdmin4 let's look at how to do some SQL queries using this GUI.

## Creating a SQL query on a database or table

There are several ways to create a SQL query, most of which involve a right-click of the mouse. 

To bring up an empty query box on your database:
1. Make sure your database or one of it sub-objects is selected in the left nav
2. click on the lighting icon on the top of the left nav area

![Icon for Query](basicpgadmin/assets/03-lightning.png)

In the right pane you now have a right text area to write a query or multiple queries. For now just write:

```SELECT * from se_locations;```{{copy}}

to select all the records of storm event locations.

To execute this query either:
1. Press F5 on your keyboard 
1. Click on the lightning icon on the top of the query area

![Icon for Query](basicpgadmin/assets/03-execute-query.png)

Once the query is done executing you will see a nice tabular view of the data on the bottom of the right pane. The column 
names and data values will be displayed as well. 

## Wrap Up

With that we have concluded our basic introduction to PostgreSQL functions. We did not actually go into specifics of PL/PGSQL
or PL/Python nor did we cover any of the more advanced ways of working with function results like Lateral Joins and such.
Those will be topics for later classes. 

The main goal was really to get you to understand the basic structure of functions, how to pass data in and out, and get
your hands dirty. Hopefully you now have a good foundation for diving into [more of](https://www.postgresql.org/docs/current/plpgsql.html) 
the [core documentation](https://www.postgresql.org/docs/current/extend.html).