# Getting Started With Functions in PostgreSQL

This class gives you a basic introduction to writing functions which can be used to add functionality to PostgreSQL. We are not going to 
cover functions in depth, but instead this class will prepare you for some of the core concepts needed in other scenarios.


## Functions Are Everywhere in PostgreSQL
PostgreSQL is quite well know for its flexibility and extensibility. One of the ways that it achieves this ability is because
almost everything in PostgreSQL is a function. For example, all the base datatypes are actually functions that translate
from the underlying binary types to the human readable forms. Another example is the **+** operators. It is actually a function
written in C that takes arguments from both sides of the operator and returns the result. 

Here is a list of all the places PostgreSQL uses functions:
- Functions
- Operators
- Data types
- Index methods
- Casts
- Triggers
- Aggregates
- Ordered-set Aggregates
- Window Functions 

Stored procedure and triggers are the most common places you will use functions. 

## Languages to Use When Writing Functions

PostgreSQL has a wide array of programming languages you can use to write functions. 

You [can use](https://www.postgresql.org/docs/11/external-pl.html):
- SQL
- PL/pgSQL: a procedural language included in PostgreSQL maintained by the PostgreSQL foundation (similar to Oracle's PL/SQL)
_ We will be using mostly SQL with some pgSQL as our main languages for this scenario_
- PL/Tcl  
- PL/Perl
- PL/Python: Python 2 and 3, with 2 still being the default (unfortunately)
- PL/V8 (JavaScript)
- PL/Java
- PL/R
- PL/Ruby
- PL/Lua
- PL/Shell


Here are the details on the database we are connecting to:
1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: workshop

 Let's get started
