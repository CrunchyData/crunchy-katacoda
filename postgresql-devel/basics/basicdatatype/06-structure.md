## Your database structure

Since data types have to be set when creating new table columns, this does 
imply that you should have already done some planning around what kind of data
you'll be storing and what it'll be used for. 

In the preceding [course for 
`CREATE TABLE`](.../basictable), you'll notice 
that we actually start out by identifying a real-world business scenario, and 
then translate that into a data model. Doing this kind of planning allows you 
to choose the most appropriate data types out of a few possible options, and 
helps you use the database more efficiently.

## Operators and functions

There are many built-in operators and functions in Postgres for processing 
text, numeric, and date/time values. There's a lot to talk about there that's 
beyond the scope of this introductory course, so we'll have to cover it in 
another course. In the meantime, feel free to check out the 
[official docs](https://www.postgresql.org/docs/current/functions.html) to 
familiarize yourself with some of them. 

A knowledge of what these database operators and functions can do will 
definitely help you not just get more out of your database, but improve your 
application as well (for example, by simplifying the application codebase).
