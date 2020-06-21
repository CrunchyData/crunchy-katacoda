# Common LATERAL use-cases

## Set Returning Functions (SRFs)

One of the ways in which LATERAL is particularly useful is that it allows you to take the rows from one table and pass them in as arguments to a Set Returning Function (SRF).

There's a number of built-in SRFs in PostgreSQL, the most commonly used one likely being 'generate_series'.

```sql
select * from generate_series(1,4) cross join generate_series(1,generate_series.generate_series) as g2 (gs2);
```{{execute}}

Notice how the 'c1' column from 'mytable' is being passed in to generate_series(), one time for each row of mytable, resulting in that many additional rows being added to the output.

You may have also noticed that we didn't actually write 'lateral' in our query, what happened?

As it turns out, PostgreSQL, in some cases like when an SRF is being used, is able to figure out that what you were asking for was really a LATERAL and just automatically turn the query into a lateral join.

Of course, you can include lateral in the query if you want to be explicit and make it clear what's happening, like so:

```sql
select * from generate_series(1,4) cross join lateral generate_series(1,generate_series.generate_series) as g2 (gs2);
```{{execute}}

While this generate_series example isn't a terribly exciting case, there's lots of situations where this is particularly useful as we will see next.

## Wrap Up

We have now seen an example of how LATERAL joins can be useful with the generate_series SRF.  Next we will look at a few other examples which have more real-world use.
