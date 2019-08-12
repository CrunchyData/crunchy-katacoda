# Navigating Around Your Database Using PgAdmin4

Now that we have our shiny new connection to our server let's explore how to use PgAdmin to nagivate around.

## Top Level

Go ahead and click on the Workshop server in the left nav bar. Your right hand pane should transform to something that looks 
like this (without the red highlight boxes):

![Top Level View](basicpgadmin/assets/02-top-level.png)

The top highlighted area shows you statistics on your current server for all the current sessions connected to the server. 
The bottom area shows you all the current running Postgres processes (PID = process ID), and if applicable, information 
about the database and user who is associated with the process.

The blue dashed box along the top highlights other tabs that apply to the current item selected in the left nav. 

In this case, there is not much interesting information on those tabs so we will late until later to explore them.    

## Finding Our Database

Alright time to dig in and find our actual database which is named "workshop". 

You know the next step in our function right? Of course we need to get it so say "Hello [your name]". Let's start with the 
simplest way possible

```
CREATE OR REPLACE FUNCTION brilliance(varchar)
RETURNS VARCHAR AS
```{{execute}}

We are saying that this function requires the caller to pass in a string along with the function call. From the PostgreSQL
documentation: 

    The argument types can be base, composite, or domain types, or can reference the type of a table column.
    
Just use the type as if you were defining a column in a table. 

### Referencing the Parameter in the Code

Now we can use this parameter in the code. 

```
$$
   SELECT 'hello ' || $1;
$$
LANGUAGE sql;
```{{execute}}

If we had used more parameters we would keep incrementing the $number for each new parameter. The '||' is the concatenation 
operator per the SQL standard. 

Let's go ahead and use our cool new function!

```
select brilliance('student');
```{{execute}}

Go ahead and change the name to anything else you want to try. 

## Better Parameter Names

While it was easy to just put in 'varchar' for the parameter, that is not as easy to use and read in the body of our code. 
Let's clean this up and make more literate code. You can give a name to the parameter and it appears right before the type
declaration. We will also add another parameter so you can see how to handle passing in multiple named variables.

```
CREATE OR REPLACE FUNCTION brilliance(name varchar, rank int)
RETURNS VARCHAR AS
$$
   SELECT 'hello ' || name || '! You are number ' || rank;
$$
LANGUAGE sql;
```{{execute}}

This code is much more readable and maintainable. We also got to see that the '||' operator will work with non-string types 
as long as there is one string type in the concatenation. 

Time to exercise our function again:

```
select brilliance('student', 1);
```{{execute}}



## Default Values for Parameters

It is also possible to specify default values for parameters for when the function is called without a value for a parameter. 
**Note**, if you have a list of parameters, once you specify a default value for a parameter ALL following parameters must 
have default values as well. 

Let's go ahead and specify default values for both parameters in our great new function. 

```
CREATE OR REPLACE FUNCTION brilliance(name varchar = 'Jorge', rank int = 7)
RETURNS VARCHAR AS
$$
   SELECT 'hello ' || name || '! You are number ' || rank;
$$
LANGUAGE sql;
```{{execute}}

And now if we call our function we will get those values if we don't specify a value. Before we do this we need to drop our
original function - think about why?....


```
DROP FUNCTION brilliance();
```

Since we already wrote a function named brilliance in step 1  that accepted no parameters, it is going to try and use that 
rather than what we want to happen here. 

```
select brilliance();
```{{execute}}

But we can also specify only one parameter and use the parameter name. Read more in the [official docs](https://www.postgresql.org/docs/11/sql-syntax-calling-funcs.html) about how
to call functions:

```
select brilliance(rank => 1);
```{{execute}}


## Wrap Up

**NOTE** No two functions can have the same name UNLESS they have  different parameter signatures. 
For example, you can't have two functions named _myfunction_ unless one is myfunction() 
and the other is myfunction(myparam varchar). You could actually have functions:
1.  myfunction() 
1.  myfunction(varchar)
1.  myfunction(int) 

As long as the parameters are different (order does not matter) they can co-exist. What this also means is that you can 
overload a function to  do different behavior depending on the types passed in.As we saw above, having default values
along with over-ridden function names can sometimes cause issues for the users of the functions.
Keep this in mind if you run into an error or trying to determine how to architect your functions. 


Though we covered the basics of adding parameters to your functions we will return to this as we move on to the next section. 
In the next exercise we will cover different ways to return values and how to handle different return types. 
