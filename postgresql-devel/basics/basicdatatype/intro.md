# Data Types in PostgreSQL: An Introduction

In these next few scenarios, we'll focus on data types in PostgreSQL. From the 
previous scenarios, we've learned how to log in to a Postgres database, create 
data tables, and even add values to those tables. You'll recall that when we 
create a table, we have to define what kind of data each column will store.

If you have programming experience, the concept of data types isn't new. 
Data types in relational database management systems such as Postgres follow
a lot of the same general principles, so this course will serve mostly as a
refresher. 

Since this is an introductory course, we'll focus on three of the most common 
data types in Postgres: character types (`char`, `varchar`, and `text`), 
numeric (including `integer` and `decimal`/`numeric`), and date/time (including
 `date` and `timestamp`). With that said, we'll also introduce some concepts that 
 are pertinent to Postgres and databases in general.

## Using the Command Line

This course will use `psql` to navigate and do updates in the database. If 
you're not familiar with `psql`, we'd encourage you to check out the preceding
[introductory course on `psql`](../basics/intropsql) in 
this series first, before diving in to this course.