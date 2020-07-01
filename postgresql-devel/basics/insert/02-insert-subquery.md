In addition to explicitly supplying the values you want to add, you can also 
use a **subquery** with INSERT. 

You can use this syntax if the data is available from another table:

```
INSERT INTO attendance (client_id, event_id, attend_status)
VALUES (
    2,
    (SELECT id FROM event where lower(event_dt) = '2020-01-11 17:00'::timestamptz),
    'Canceled'
);

SELECT * FROM attendance;
```{{execute}}

Using a subquery is helpful for when you don't have the precise value on hand, 
or when you want to ensure data integrity. For example, if we had instead 
created a separate lookup table for the possible `attend_status` values, we 
could still select the correct value from that lookup table even without 
worrying about any label changes we may make in the future (such as from 
`'Canceled'` to `'Cancel'`.)

Before we continue to the next step, let's add a few more rows to the 
attendance table:

```
INSERT INTO attendance (client_id, event_id, attend_status)
VALUES (1,
    (SELECT id FROM event where lower(event_dt) = '2020-01-11 17:00'::timestamptz),
    'Attended'),
    (5,
    (SELECT id FROM event where lower(event_dt) = '2020-01-11 17:00'::timestamptz),
    'Attended'),
    (3,
    (SELECT id FROM event where lower(event_dt) = '2020-01-11 17:00'::timestamptz),
    'No Show');
```{{execute}}

Notice that in this case we are adding multiple rows using a single INSERT
command. The VALUES clause will accept multiple rows by having 
multiple sets of values (in parentheses) separated by commas.  Multi-row inserts 
are more performant than multiple single row inserts. If you'd like to
see other fun things you can do, see what happens if you don't include the INSERT
clause and just type: 

```
VALUES (1), (2), (3);
```{{execute}}

Read more about the VALUES clause in the [official docs](https://www.postgresql.org/docs/current/queries-values.html).
