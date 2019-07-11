# Return Types

For this final section we are going to cover all the ways you can return data from your functions as well how to handle
different data return types. Let's move on from just returning a single value and perhaps throw in a little Pl/PGSQL the
procedural language included with PostgreSQL. 

We will start by showing how the actual RETURN statement is not necessary.

## IN, OUT, and INOUT Paremeters

PostgreSQL allows you to specify the "direction" data flows into a function based on how you declare the parameter. By 
default all parameters are specified as IN parameters, meaning data is only passed into the function with the parameter. 

If you declare a parameter as OUT then data will be returned. You can have more than one OUT parameter in a function. Using a 
RETURNS {type} AS statement when you have OUT parameters is optional. If you 
use the RETURNS {type}AS statement with your function, it's type must match the type of our OUT parameters. 

An INOUT parameter means it will be used to pass data in and then return data through this parameter name as well

For our function let's get rid of the RETURNS {type} AS statement and add another OUT parameter. We have to drop our function first
because Postgresql does NOT consider OUT parameters as a change in signature but by adding the OUTs we are changing the 
return type. 

```
DROP FUNCTION brilliance(varchar, int);
CREATE OR REPLACE FUNCTION 
brilliance(name varchar = 'Jorge', rank int = 7, out greetings varchar, out word_count int) 
AS

```{{execute}}

We left the original signature in place but now we added two OUT parameters: 1) greetings which will hold the full statement 
and 2) word_count which will hold the count of characters in the greetings parameter. 

Now let's alter the body of the text.

```
$$
    BEGIN
       greetings := (SELECT 'hello ' || name || '! You are number ' || rank);
       word_count := length(greetings);
    END;
$$
LANGUAGE plpgsql;

```{{execute}}

Remember that if we left the language as SQL it would only return the final value and we couldn't really do the assignment of 
values to parameters. So we change the language to Pl/PGSQL. Now we get access to the **:=** [assignment operator}(https://www.postgresql.org/docs/11/plpgsql-statements.html). 

Because we are using PL/PGSQL we also need to wrap out code in BEGIN and END; statements. Finally, the := operator can only be used
for assignment of a single value or a single row we need to wrap our select statement in ( ) to coerce to a single value.

### Using this new and improved function:

When we use this function:

```
select brilliance();
```{{execute}}

Notice we get a different type of result:

```
workshop=> select brilliance();
              brilliance              
--------------------------------------
 ("hello Jorge! You are number 7",29)
(1 row)

```

We get a single column result with a name matching the function name. For the value we get an array containing our two values.
You can think of this as PostgreSQL coercing all our OUT variables into an array. It would continue appending to 
the array for every OUT or INOUT variable we declared. Technically what happened is the our result is actually created an 
anonymous record type to hold the output. 


Let's make it a bit nicer to read:

```
select * from brilliance();
```{{execute}}

Which should give you a result like this:

```
workshop=> select * from brilliance();
           greetings           | word_count 
-------------------------------+------------
 hello Jorge! You are number 7 |         29
(1 row)

```

Now we get a row result but the column names match the OUT variable names. Again if we add more OUT variables the result 
would just have more columns. 

## Different Data Types to Return

So far all we have returning simple values that match base types in SQL. As mentioned earlier you can 
return anything you can use to define a column in a table, even your custom defined type. 
Quite often you are going to want to return a row in a table or perhaps a whole table (or use them as OUT parameters):

1. RETURNS RECORD - A record can be thought of as a single row in an arbitrary table. 
1. RETURNS {tablename} - If you want a row to obey the schema of a table you can just pass in the table name.
1. RETURNS SETOF RECORD - By adding the SETOF to the statement you can now return multiple records (rows)
1. RETURNS SETOF {tablename} - And by extension, this will return multiple rows with a schema that obeys the table schema

Specific to the RETURNS X AS, you can actually define a table in the place of X. For example:


```
CREATE FUNCTION my-little-table()
RETURNS TABLE (id int, name text, quarter tsrange)
As $$
```


## Wrap Up

With that we have concluded our basic introduction to PostgreSQL functions. We did not actually go into specifics of PL/PGSQL
or PL/Python nor did we cover any of the more advanced ways of working with function results like Lateral Joins and such.
Those will be topics for later classes. 

The main goal was really to get you to understand the basic structure of functions, how to pass data in and out, and get
your hands dirty. Hopefully you now have a good foundation for diving into [more of](https://www.postgresql.org/docs/current/plpgsql.html) 
the [core documentation](https://www.postgresql.org/docs/current/extend.html).