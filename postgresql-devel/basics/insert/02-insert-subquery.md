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
