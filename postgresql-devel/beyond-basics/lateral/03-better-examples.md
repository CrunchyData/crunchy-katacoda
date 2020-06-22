# Common LATERAL use-cases

## LATERALs with real-world SRFs

Consider if you had a geocode() SRF, which returns the best matching result for
the address which is passed in to it.  With such an SRF, if you had a table of addresses you would be able to write a query such as:

```sql
select * from myaddresses cross join lateral geocode(address);
```

Note that in the above example, 'address' is (one of the) columns in the 'myaddresses' table.

Which would return all the results from the geocode() function for each address passed in.

## Top-N Results

Another really useful case for LATERAL is when you're looking to find the top-N rows (or even just the very top row, similar to the max() aggregate function), such as if you want to find the last 5 fatalities
by fatality date for each severe event, you could write a lateral join like so:

```sql
select event_id, state, fatality_id, fatality_date from se_details cross join lateral (select fatality_id, fatality_date from se_fatalities where se_details.event_id = se_fatalities.event_id order by fatality_date desc limit 5) as fatalities;
```{{execute}}

## Top-N Results for all cases

Expanding on the Top-N case a bit, it can also be useful to left-join using a lateral, to ensure that each item has a row in the result, even if there isn't anything returned from the top-N query.  Doing so
with our query above gives us at least one row for every event, returning NULL in the fatalitiy columns if there weren't any fatalities associated with a given event:

```sql
select event_id, state, fatality_id, fatality_date from se_details left join lateral (select fatality_id, fatality_date from se_fatalities where se_details.event_id = se_fatalities.event_id order by fatality_date desc limit 5) as fatalities on true;
```{{execute}}

This will return at least one row for every event in se_details, and return the top five (or as many as exist, if there are fewer than 5 results) in descending order of fatality date in the fatalities
table for that event.

You may notice that in this case we had to include an ON clause (the 'on true' at the end), this is because we are using a left join, which requires an ON clause, so that rows from the 'se_details' table are
returned even if they don't have any rows returned from the 'se_fatalities' lateral sub-query.

## Wrap Up

We have now seen a few examples of how LATERAL joins can be useful.
