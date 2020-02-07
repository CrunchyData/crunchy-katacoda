# The very basics of EXPLAIN

Let's start by doing some simple uses of EXPLAIN and the various output options.

For our first query let's just return the ids from the Storm Details table (se_details). Let's just refresh our memory with a plain SQL where we will limit the results to the first 5 entries just so we don't have to scroll through pages of output (there are over 60K storms in the table).
> NOTE: Clicking on the black box below will execute the statement in the console window to the right.


```sql92 
select event_id from se_details limit 5;
```{{execute}} 

Now let's see how the Query Planner analyzed this query (without the limit):

```sql92
EXPLAIN select event_id from se_details;
```{{execute}}

Your output should look like this (without the red numbers)

![First Explain Output](basics/explain/assets/01-first-explain.png)

Time to explain the basic pieces of explain output. 

Since we have a very simple query we only have one line grouping in our query plan. This line is called a node in the PostgreSQL technical documentation because it represents a node in a tree. As you will see later more involved trees are usually generated. 
  
Now let's dissect the information in the node - each number below corresponds to the red number on the image. 

(1) Seq Scan - this stands for sequential scan. This first part of the information says the type of operation the query will do. Since we are pulling back the whole table there is no use of an index or a filter and the query planner is going to use a simple sequential scan of all rows in the table. Another name for a sequential scan is a [Full Table Scan](https://en.wikipedia.org/wiki/Full_table_scan).

The next **cost** section has two parts.  

(2) This first number (0.00) represents the elapsed time before this node can start returning results. Since there is only one node in this query plan it can start right away. The units for this figure are "in arbitrary units determined by the planner's cost parameters". By default it is roughly based on disk page fetches. You can read more in the [explain documentation](https://www.postgresql.org/docs/11/using-explain.html) 

(3) The second number represents the total estimated cost for this node to complete. Again, the units here are in the same arbitrary units given above. It is important to note that this cost is **NOT** comparable between queries.   

(4) Rows represents the number of estimated rows returned when the node is finished. In this case, since we are returning every row it is the same as the table size. Note this is the maximum rows that might be returned but the node can return earlier if it meets some criteria such as a *LIMIT*.

(5) The final number is size in bytes for each row returned from the node. Since we are only returning an integer we get 4 bytes. If you want to try something change the select to  `select * from ...` and watch the return row size increase. 

All of these statistics on the node apply per time the node is executed. You will see why this is important later when we get to query plan that contain loops.   

## Wrap Up

You have seen how we can get same basic statistics on what the query planner has chosen as the "optimal" tree of execution. In the next section we will look at what happens when we ask EXPLAIN to look at the actual statistics of the plan.