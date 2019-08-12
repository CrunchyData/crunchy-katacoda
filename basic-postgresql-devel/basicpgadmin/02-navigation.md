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

To open the connection, click on the little arrow next to the elephant with the word Workshop after it. You are now inside 
your DB server. By default you are connected to the "postgres" database 


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
