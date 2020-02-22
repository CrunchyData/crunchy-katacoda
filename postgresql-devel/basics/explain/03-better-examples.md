# More Interesting Examples

Since you now know how to read the basics of an EXPLAIN (ANALYZE) query, let's start both using that knowledge and expand our explanation of the output.

## When your query has a WHERE clause

Let's add a WHERE clause to our query. We will ask for all the ids of all the storms that happened in the home state of the class author:

```sql
EXPLAIN ANALYZE select event_id from se_details where state = 'NEW YORK';       
```{{execute}}   

You should see output something like this:

![Filter Node](basics/explain/assets/03-with-filter.png)

So again we are doing a sequential scan and the rest of the output looks standard. What's new is the second and third lines. We now see that the planner is using a filter because we put in a WHERE clause. It tells us the exact syntax of filter (for example we see that the query planner cast our input string by using *::text* since we didn't explicitly cast our string to a SQL type). The third line tells us how many records were excluded with the filter, in this case we reduced the number of records by quite a bit, filtering out most of them and only returning a relatively small amount.

The fact that we did a sequential scan with a WHERE clause, and most of the rows were eliminated by the filter, indicates that the query planner did not have an index it could use to help make the query more efficient. 

### Adding an index and re-querying
Let's go ahead and add an index and see what happens with the query planner.

```sql
create index se_details_state_idx on se_details(state);
```{{execute}}
   
and now let's run our filtered query again

 ```sql
 EXPLAIN ANALYZE select event_id from se_details where state = 'NEW YORK';       
 ``` {{execute}}

Your output should look something like this:

![Filter Node with Index](basics/explain/assets/03-with-filter-index.png)

One of the first things you should notice is that we get a significant reduction in execution time. PostgreSQL took advantage of the new index we just created and it significantly reduced the execution time of our query.

Another nice part of this query is that now we get to see the tree like nature of the query plan. The terminal node of the tree is highlighted in the red rectangle and the  final node is highlighted in the yellow rectangle. The terminal node is also indented to denote it being below the top node.

 
 You may be wondering why the query planner had to actually do two steps to carry out this query. Why couldn't it just use the index to look up the right rows and then return them? The query planner actually did consider using an Index Scan to find the rows and then look up each one in the table, but decided that wasn't the most efficient way to get the answer.  Instead, node goes through the index and makes a note of each matching row in an in-memory Bitmap data structure and, once it found all the matches in the index, it then used the bitmap to perform a sequential scan of the table, skipping to each position for matching row, read that page of data from disk, and then returned the result.
 
 There are a few reasons why a Bitmap Heap Scan may be more efficient than an Index Scan: 
 
1. If the planner believes a lot of the table is going to be returned anyway, a Bitmap Heap Scan will scan the table in a closer-to-sequential method, unlike the random access which would be caused by an Index Scan. Reading sequentially from disk is always faster than random access, and the effect grows larger as more data needs to be read. 
1. Though we didn't do it with our query, a Bitmap Heap Scan can use multiple indexes (with a BitmapAnd or BitmapOr) to find the matching rows.

If you want to see all the "default" node types you can look in the source [file here])(https://gitlab.com/postgres/postgres/blob/master/src/include/nodes/plannodes.h). We say default because extensions and other add-ons can always bring in new node types.

## A join query 

Let's move on to seeing how the query planner would satisfy a join query. We will build on the last example by adding a WHERE clause to our join as well. We have another table that, if there are fatalities from storm, will provide details on the fatality. Let's join our storm event table against that table:

```sql
EXPLAIN ANALYZE select d.event_id, d.state, f.fatality_age, f.fatality_location
from se_details as d, se_fatalities as f where d.event_id = f.event_id AND d.state = 'NEW YORK';
```{{execute}}
  
and again your output should look something like this:

![Join Query](basics/explain/assets/03-join.png)

So there are actually 3 nodes in this query. The node in yellow rectangle (the sequentical scan) and node in the red rectangle (the index scan) which are both children of the node in the green rectangle (the nested loop). 

To do the join the query planner has to match the event_id between both tables. Since we need at least one list of keys to join on the planner does a sequential scan on the se_fatalities table to get event ids. You can see that the yellow node returns 613 records, the total number records in the se_fatalities table. The query planner chose to do a sequential scan on se_fatalities which gives us a smaller list of event_ids to compare. 

All of those records are then fed one at a time into the index scan node to test first for a match on the event_id, if one exists, and then to filter on the condition in the WHERE clause. This is why the index scan has 802 loops. Had we made an join index on both event_id and state in the se_details table, the planner would have done a direct index scan without having to do a loop.

In reality, both nodes are running in concurrently so that the index node does not have to wait for the  sequential scan node to finish before it starts check the equality conditions. As the sequential scan pulls a row it feeds it directly into the index scan. This is NOT a parallel query but merely the executor not having to wait for the whole node to finish before starting the other node. Had we put an ORDER BY clause in our query then the node would have to finish before it could pass data to the other node.

> Note: since we are doing 613 loops on this node, the timings we are getting back for actual time are the time **per loop**. Which means this node will take ~ 0.613 milliseconds to finish for this example.   

## Wrap Up

In this section we got to see filters, different node types, and multi-level trees. You have been introduced to most of the major features or explain analyze output. In the next section we will look at other ways to report explain resuts and another tool to help you visualize your explain results.
