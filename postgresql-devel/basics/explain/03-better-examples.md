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

One of the first things you should notice is that we get an ~9x reduction in execution time. PostgreSQL took advantage of the new index we just created and it significantly reduced the execution time of our query.

Another nice part of this query is that now we get to see the tree like nature of the query plan. The terminal node of the tree is highlighted in red and the
 final node is highlighted is yellow. The terminal node is also indented to denote it being below the top node. All nodes at the same level of indentation will execute at the same time.
 
 You may be wondering why the query planner had to actually do two steps to carry out the query. Why couldn't it just use the index to look up the right rows and then return them? The query planner created two steps because:
 
1. The index does not have information about the permissions on the data. We need to check the results against the data visibility permissions for the current user.
2. The query planner may sometimes over sample the data using an approximate match and then do an expensive exact match in the second step.

In this case you can see that the terminal node returned 1954 rows to the second node, which also happens to be the size of the final query result.

If you want to see all the "default" node types you can look in the source [file here])(https://gitlab.com/postgres/postgres/blob/master/src/include/nodes/plannodes.h). We say default because extensions and other add-ons can always bring in new node types.

## A join query 

Let's move on to seeing how the query planner would satisfy a join query. We will build on the last example by adding a WHERE clause to our join as well. We have another table that, if there are fatalities from storm, will provide details on the fatality. Let's join our storm event table against that table:

```sql
EXPLAIN ANALYZE select d.event_id, d.state, f.fatality_age, f.fatality_location
from se_details as d, se_fatalities as f where d.event_id = f.event_id AND d.state = 'NEW YORK';
```  
and again your output should look something like this:

![Join Query](basics/explain/assets/03-join.png)

So there are actually 3 nodes in this query. The yellow and red nodes are both children of the green node (nested loop). 
To do the join the query planner has to match the event_id between both tables. Since we don't have an index on event_id in the se_fatalities table PostgreSQL will need to do a sequential scan on the se_fatalities table to get event ids. You can see that the yellow node returns 802 records, the total number records in the se_fatalities table. The query planner chose to do a sequential scan here because it needs a set of event_id to use in the join and se_fatalities gives us a smaller list to compare. 

All of those records are then fed one at a time into the red node to test both of the equality conditions. This is why the red node has 802 loops. We get an index scan on this node because the query engine can use the index on state and event_id to check the join and 'NEW YORK' both meet the equality condition. 

In reality, both nodes are running in parallel so that the red node does not have to wait for the yellow node to finish before it starts check the equality conditions. As the sequential scan pulls a row it feeds it directly into the index scan

> Note: since we are doing 802 loops on this node, the timings we are getting back for actual time are the time **per loop**. Which means this node will take ~ .802 milliseconds to finish.   

## Wrap Up

In this section we got to see filters, different node types, and multi-level trees. You have been introduced to most of the major features or explain analyze output. In the next section we will look at other ways to report explain resuts and another tool to help you visualize your explain results.
