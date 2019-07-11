# Our First Function

Let's lay a little groundwork so we can write our first function. There are some basic pieces all functions, regardless 
of programming language, need in order to work.

## Basic Pieces of Every Function

Just like functions in other languages, PostgreSQL functions have certain structure and syntax. Let's avoid dealing 
with parameters for the time being and just make the simplest function possible. We are just going to make a simple 
function that returns, get ready for it, the string "hello world".

### The Declaration - the name and parameters

Let's go to terminal, which is already at the psql interactive prompt.  To being with we need to start the opening 
block of the function and give it a name. Please note the capitalization for SQL reserved words is optional but done
here for clarity. 

```
CREATE FUNCTION brilliance()
```{{execute}}

We are declaring a function named "brilliance" and saying it doesn't accept any parameters. We will return to cover this
declaration in more depth later in the scenario. 

### Return Declaration

We already stated we are going to return a string so let's go ahead and set that up. In later scenarios we will explore 
other return types. 

```
RETURNS VARCHAR AS
```{{execute}} 

### Function Body
Now we can write our function body. We demarcate the begin and end of the code with $$ symbol. We use $$ rather than " or
' so that we don't have to bother escaping strings in our code. When using SQL as our programming language only the last 
executed line (ending in a ;) will be returned. We also *can't* use RETURN to specify which result we want to return. 

```
$$
   SELECT 'hello world';
$$
```{{execute}}

Notice we use the SQL ';' delimeters at the the end of each SQL statement. 

### Language Specification

Finally, we need to tell PostgreSQL what programming language we used in our function. In this case we are just going
to use SQL. 

```
LANGUAGE sql;
```{{execute}}

## Calling our New Function

Now to use our brand new shiny function

```
select brilliance();
```{{execute}}

Now any time we want to say "Hello World" in the _workshop_ database all we have to do is call our function.
I know this wasn't that exciting yet but hopefully, now you see the basic structure of PostgreSQL function. As mentioned
in the intro., functions form the bases for most every extra functionality we want to create, such a stored procedures.

## Wrap Up
We just finished the basic skeleton of a function: declaration, function name, parameters, return type, code block, and 
language used. In our next exercise we will explore doing more with the function declaration and parameters. 
