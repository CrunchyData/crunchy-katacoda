# Using Constraints in PostgreSQL 

One of the most valuable assets in any company is their data. While [database types](https://learn.crunchydata.com/postgresql-devel/courses/basics/basicdatatype) add basic protection to guard against invalid data entry, we can use PostgreSQL constraints to enforce even more data validity checks. The great part about doing it at the database level is that it ensures that no matter what is adding or updating data the rules will be enforced. 

You can create data constraints both at the table and column level. There are 6 different types of constraints found in PostgreSQL and we will go over a brief introduction to them in today's class.

> NOTE: while almost all the examples in this tutorial create constraints on a single column, you can usually define constraints that apply to multiple columns at the same time. 

So let's dig in and see how to use constraints.


We have loaded up a PostgreSQL database with no data so we can create schemas with constraints and then try to load data. Here are the details on the database we are connecting to:
1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: workshop

The people used for the data will be members of [Guardians Of The Galaxy](https://www.imdb.com/title/tt2015381/) movie. You don't need to know the characters to understand the exercises, but it will help you appreciate my humor.
 
Enjoy!
