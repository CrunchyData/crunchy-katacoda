# Seeing the Results of the Executed Plan

While it is helpful to see the plans of the query planner, it is even more insightful to see the timing of the query execution. To get that information we need to add the word ANALYZE after EXPLAIN. 

> CAUTION: Once you add ANALYZE, your query will actually be executed, which is low risk for selects, but will actually alter your data for write operations, like updates and deletes. Later in this step we will wrap data altering commands in a transaction to avoid changing our data while still getting actual performance numbers. 

## Using EXPLAIN ANALYZE

Let's go ahead and do the same query as the previous page only this time let's use EXPLAIN ANALYZE

```
EXPLAIN ANALYZE select * from se_details;
```{{execute}}  

You should get a result that looks like this:

![Explain Analyze Output](./assets/02-explain-analyze.png)

You should know everything up to Actual time from the last scenario. This time the new numbers are much more straightforward. Let's use the red numbers to go through the new items. 

(1) The first number in actual time is the startup time in milliseconds before the node can execute. We can see that there is a short time before the node executes

(2) The second number is the actual time in milliseconds the node took to execute per loop. In this case we only have one loop so this is the total time it took to sequential scan the table.

(3) This is the average number of rows actually returned by the node, per loop. In our case we have only one loop and the planner estimate exactly matches the actual number. We will see later that these numbers rarely match up as the estimate is based on statistics that PostgreSQL has periodically updated about the table.

(4) This is the actual number of loops that were executed. 

(5) This is the time the query planner took, in milliseconds, to formulate how it was going to do the query

(6) This is the total time, in milliseconds, it took for the query to execute. The difference is timing between total node time and the total execution time is the start up and shutdown of the executor. This does **not** include the planning time or the time it takes to return the data to the client. 


## Protecting inserts, updates, and deletes

As mentioned above, when you do an EXPLAIN ANALYZE it actually carries out the action, which, for inserts, updates, and deletes will actually alter your data. To prevent this from happening you can
 to wrap the entire EXPLAIN ANALYZE in a transaction. The entire flow is show in the console output captured below:

```sql
workshop=> select count(*) from se_details;
 count
-------
 62356
(1 row)

workshop=> BEGIN;
BEGIN
workshop=> EXPLAIN ANALYZE INSERT INTO se_details (event_id, source) VALUES (1000000, 'from Steve');
                                             QUERY PLAN
----------------------------------------------------------------------------------------------------
 Insert on se_details  (cost=0.00..0.01 rows=1 width=470) (actual time=0.031..0.031 rows=0 loops=1)
   ->  Result  (cost=0.00..0.01 rows=1 width=470) (actual time=0.004..0.004 rows=1 loops=1)
 Planning Time: 0.024 ms
 Execution Time: 0.055 ms
(4 rows)

workshop=> ROLLBACK;
ROLLBACK
workshop=> select count(*) from se_details;
 count
-------
 62356
(1 row)

```


## Wrap Up

With that we now have a good enough foundation to move on and start working with real queries. If you want to play some more while you are here, you can again do a `select event_id...` in your query and see what it does to the timing. Now let's move on to doing some more interesting queries.
