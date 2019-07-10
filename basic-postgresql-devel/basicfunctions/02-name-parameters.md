# Function Declarations and Parameters

While our function is amazing, perhaps we do want to do a bit of editing to it. Maybe accept some parameters or change 
the code. 

## Create versus Replace

Functions are immutable, there is no way to edit them in place. So while we used CREATE in our first example, the 
recommended pattern is to instead say "CREATE or REPLACE FUNCTION"

This tells PostgreSQL if this function doesn't exist then create it otherwise, replace the one that is there. From now on 
we are going to use this so we can keep iterating on our function. 

## Parameterising Our Function

You know the next step in our function right? Of course we need to get it so say "Hello <your name>". Let's start with the 
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

If we had used more parameters we would  keep incrementing the $number for each new parameter. The '||' is the concatenation 
operator per the SQL standard. 

Let's go ahead and use our cool new function!

'''
select brilliance('student');
'''

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

'''
select brilliance('student', 1);
'''


## Default Values for Parameters

HERE


Now to use our brand new shiny function

```
select brilliance();
```{{execute}}

Now any time we want to say "Hello World" in the _workshop_ database all we have to do is call our function.
I know this wasn't that exciting yet but hopefully, now you see the basic structure of PostgreSQL function. As mentioned
in the intro., functions form the bases for most every extra functionality we want to create, such a stored procedures.

## Wrap Up

No two functions can have the same name UNLESS they have  different parameter signatures. 
For example, you can't have two functions named _myfunction_ unless one is myfunction() 
and the other is myfunction(myparam varchar). What this also means is that you can overload a function to 
do different behavior depending on the types passed in. Keep this in mind if you run into an error or trying to determine 
how to architect your functions. 


We just finished the basic skeleton of a function: declaration, function name, parameters, return type, code block, and 
language used. In our next exercise we will explore doing more with the function declaration and parameters. 
