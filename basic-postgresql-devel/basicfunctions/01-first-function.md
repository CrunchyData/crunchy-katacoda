# Our First Function

Let's lay a little groundwork so we can write our first function. There are some basic pieces all functions, regardless 
of programming language, need in order to work.

## Basic Pieces of Every Function

Just like functions in other languages, PostgreSQL functions has certain structure and syntax. Let's avoid dealing 
with parameters for the time being and just make the simplest function possible. We are just going to make a simple 
function that returns, get ready for it, the string "hello world".

### The Declaration

Let's go to terminal, which is already at the psql interactive prompt.  To being with we need to start the opening 
block of the function and give it a name.

```
create function brilliance( )
```

We are declaring a function named "brilliance" and saying it doesn't accept any parameters. We will return to cover this
declaration in more depth later in the scenario. 

### Return Declaration

We already stated we are going to return a string so let's go ahead and set that up. In later scenarios we will explore 
other return types. 

```
return string
``` 

### Language Specification

Then we need to tell PostgreSQL what programming language we are going to use in our function. In this case we are just going
to use SQL. 

````
language sql
````

### Function Body
And now we can write our function body. We demarcate the begin and end of the code with $$ symbol. We use $$ rather than " or
' so that we don't have to bother escaping strings in our code. 

## Wrap Up
We just finished the basic skeleton of a function: declaration, 

