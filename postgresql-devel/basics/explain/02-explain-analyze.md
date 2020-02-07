# Seeing the Results of the Executed Plan

While it is helpful to see the plans of the query planner, it is even more insightful to see the results of the query execution. To get that information we need to add the word analyze after EXPLAIN. 

> CAUTION: Once you add analyze, your query will actually be executed, which is low risk for selects, but will actually alter your data for write, update, and deletes. Later in this step we will wrap data altering commands in a transaction to protect the integrity of our data while still getting actual performance numbers. 

## Using EXPLAIN ANALYZE

Let's go ahead and do the same query as the previous page only this time ue EXPLAIN ANALYZE

```sql92
EXPLAIN ANALYZE select event_id from se_details;
```  

You should get a result that looks like this:

![Explain Analyze Output](basics/explain/assets/02-explain-analyze.png)

You should know everything up to Actual time from the last scenario. This time the new numbers are much more straightforward. Let's use the red numbers to go through the new items. 

(1) The first number in actual time is the startup time in milliseconds before the node can execute. So we can see there is a short time before the node executes

(2) The second number is the actual time in milliseconds the node took to execute per loop. In this case we only have one loop so the total time it took to sequential scan the table

(3) This is the total number of rows actually returned. In our case the planner estimate exactly matches the actual number. We will see later that these numbers rarely match up.

(4) Again this is the actual number of loops that were executed. 

(5) This is the time the query planner took, in milliseconds, to formulate how it was going to do the query

(6) This is the total time, in milliseconds, it took for the query to execute. The difference is timing between total node time and the total execution time is the start up and shutdown of the executor. This does **not** include the planning time or the time it takes to return the data to the client. 



 



## Wrap Up


