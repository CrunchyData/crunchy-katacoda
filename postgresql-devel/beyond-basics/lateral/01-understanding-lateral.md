# The very basics of LATERAL

In SQL, it's not typically possible for a subquery in a FROM clause to reference another table that's at the same level in the JOIN.

That is to say, this isn't allowed:

> NOTE: Clicking on the black box below will execute the statement in the console window to the right.

```sql
select se_fatalities.fatality_id, se_fatalities.event_id, details.state from se_fatalities cross join (select * from se_details where se_fatalities.event_id = se_details.event_id) as details;
```{{execute}}

Note that a "cross join" is a JOIN where the condition is simply "true", which will result in a cartesian product, for additional information about cross joins, see the PostgreSQL documentation on
table expressions and Joined Tables [here](https://www.postgresql.org/docs/current/queries-table-expressions.html).

You'll get back an error saying that it's not possible to reference 'se_fatalities' from within the subquery that's at the same JOIN level.

This is because, normally, each subquery is evaluated independently.  That's generally a good thing since it gives the planner more options when it comes to deciding how to optimize the overall query, but
there are times when it's particularly useful to be able to do such a cross-reference between FROM items.

To allow these cross-references, add the keyword LATERAL to the query, like so:

```sql
select se_fatalities.fatality_id, se_fatalities.event_id, details.state from se_fatalities cross join lateral (select * from se_details where se_fatalities.event_id = se_details.event_id) as details;
```{{execute}}

By doing so, we associate the two FROM items with each other in such a way that the left-hand side ('se_fatalities' in this example) will be stepped through, one row at a time, and the value from each row will
be used in the right-hand side subquery.  Another way to think of this is that for each row from the left table of the join will be "applied" to the expression on the right side of the lateral join.  This kind
of a join is called a "Nested Loop Join" and is the only option available to the planner when LATERAL is used, so it should be used sparingly.

## Wrap Up

You have now seen how using LATERAL will allow you to reference another table from within a subquery at the same JOIN level.  In the next section we'll look at some common use-cases for LATERAL.
