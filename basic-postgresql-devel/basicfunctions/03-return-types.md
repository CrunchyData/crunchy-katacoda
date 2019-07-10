# Return Types

For this final section we are going to cover all the ways you can return data from your functions as well how to handle
different data return types. Let's move on from just returning a single value and perhaps throw in a little Pl/PGSQL the
procedural language included with PostgreSQL. 

We will start by showing how the actual RETURN statement is not necessary.

## IN, OUT, and INOUT Paremeters

PostgreSQL allows you to specify the "direction" data flows into a function based on how you declare the parameter. By 
default all parameters are specified as IN parameters, meaning data is only passed into the function with the parameter. 

If you declare a parameter as OUT then data will be returned. You can have more than one OUT parameter in a function. Using a 
RETURNS <type> AS statement when you have OUT parameters is optional. If you 
use the RETURNS <type> AS statement with your function, it's type must match the type of our OUT parameters. 

An INOUT parameter means it will be used to pass data in and then return data through this parameter name as well

For our function let's rid of the RETURNS <type> AS statement and add another OUT parameter

```
CREATE OR REPLACE FUNCTION brilliance(name varchar = 'Jorge', rank int = 7, out greetings varchar, out word_count int)

```{{execute}}

We left the original signature in place but now we added two OUT parameters: 1) greetings which will hold the full statement 
and 2) word_count which will hold the count of characters in the greetings parameter. 

Now let's alter the body of the text.

```
$$
   greetings := SELECT 'hello ' || name || '! You are number ' || rank;
   word_count := length(greetings);
$$
LANGUAGE plpgsql;
```{{execute}}

Remember that if we left the language as SQL it would only return the final value and we couldn't really do the assignment of 
values to parameters. So we change the language to Pl/PGSQL. Now we get access to the **:=** [assignment operator}(https://www.postgresql.org/docs/11/plpgsql-statements.html)



## Different Data Types to Return

## Wrap Up
We just finished the basic skeleton of a function: declaration, function name, parameters, return type, code block, and 
language used. In our next exercise we will explore doing more with the function declaration and parameters. 
