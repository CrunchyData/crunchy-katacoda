# Return Types

CHANGE THIS TEXT 
## Language Specification

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
