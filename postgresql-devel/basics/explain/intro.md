# Getting Started With Functions in PostgreSQL

This class helps you understand how to interpret and use EXPLAIN with your PostgreSQL queries. EXPLAIN (and EXPLAIN ANALYZE) show you the planned (and actual) solution the PostgreSQL query planner uses to satisfy your query. 

## Query Planner
One of the most important part of any RDBMS is the query planner - the piece of the stack that takes your SQL and determines the most efficient method to analyze the data to get you the correct result. Quoting the [PostgreSQL documentation](https://www.postgresql.org/docs/current/planner-optimizer.html)

> The task of the planner/optimizer is to create an optimal execution plan. A given SQL query (and hence, a query tree) can be actually executed in a wide variety of different ways, each of which will produce the same set of results. If it is computationally feasible, the query optimizer will examine each of these possible execution plans, ultimately selecting the execution plan that is expected to run the fastest.

## What is EXPLAIN and EXPLAIN ANALYZE

When use use EXPLAIN in front of your SQL query, instead of getting the results of the query, you get the plan the Query Planner would have used to execute your query. The format of the results is plain text but you can also ask for other formats (we will do this in the exercises). The results will include estimates of how long the query will take, how many rows will be returned and their size per row, and if any indices will be used. If you want to see the actual numbers for how the query performs you should use EXPLAIN ANALYSE. 

> WARNING: EXPLAIN ANALYSE actually executes the SQL - so if your SQL is an update or delete it will actually change your underlying data! If you want to see actual timings for update, create, or delete queries but not change your data, wrap the statement in a transaction block that you rollback. 

### One of your primary diagnostic tools for query performance will be using EXPLAIN.

So let's dig in and see how to use EXPLAIN.

We have loaded up a PostgreSQL database with Storm Event data from 2018 in the US. Here are the details on the database we are connecting to:
1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: workshop
