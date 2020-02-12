# More Interesting Examples

Since you now know how to read the basics of an EXPLAIN (ANALYZE) query, let's start both using that knowledge and expans our explanation of the output.

## When your query has a WHERE clause

Let's add a WHERE clause to our query. We will ask for all the ids of all the storms that happened in the home state of the class author:

```sql92
EXPLAIN ANALYZE select event_id from se_details where state = 'NEW YORK';       
```   

You should see output something like this:

![Filter Node](basics/explain/assets/03-with-filter.png)

So again we are doing a sequential scan and the rest of the output looks standard. What's new is the second and third lines. We now see that the planner is using a filter because we put in a WHERE clause. It tells us the exact syntax of filter (for example we see that the query planner cast our input string by using *::text*). The third line tells us how many records were excluded with the filter, in this case we reduced the number of records returned to 1985.

The fact that we did a sequential scan with a WHERE clause indicates that the query planner did not have an index it could use to help make the query more efficient. 

### Adding an index and re-querying
Let's go ahead and add an index and see what happens with the query planner.

```sql92
create index se_details_state_idx on se_details(state);
```   
and now let's run our filtered query again

 ```sql92
 EXPLAIN ANALYZE select event_id from se_details where state = 'NEW YORK';       
 ```

Your output should look something like this:

![Filter Node with Index](basics/explain/assets/03-with-filter-index.png)


## Wrap Up
