### A few helpful functions and operators

#### `lower()` and `upper()`

The `lower()` and `upper()` functions return the lower and upper boundaries 
of the range, respectively:

```
SELECT lower(event_dt) AT TIME ZONE 'America/Los_Angeles' AS "Start Time",
        upper(event_dt) AT TIME ZONE 'America/Los_Angeles' AS "End Time",
        name AS "Event Name"
FROM event
ORDER BY "Start Time";
```{{execute}}

(`AT TIME ZONE` will return a `timestamp without time zone` value, converted to
 the specified time zone, so in this query we're showing all timestamps on West
 Coast time. Recall that timezone can also be set with the `TimeZone` parameter,
 which is something you could do in your application code as well so that it 
 matches the user/client's time zone.)

#### Contains (`<@`>)

Let's say we want to know what events have been scheduled at a particular day 
and time. We can use the `<@` operator to check whether some event in 
our table _contains_ that desired time:

```
SELECT * FROM event
WHERE event_dt @> '2020-06-26 16:30:00 PDT'::timestamptz;
```{{execute}}

(The timestamps should be in UTC per this environment's `TimeZone` setting.)

#### Overlap (`&&`)

We could also write a query that shows us if there are any events that have 
overlapped in schedule:

```
SELECT lower(e1.event_dt) AT TIME ZONE 'America/Los_Angeles' AS "Start Time",
        upper(e1.event_dt) AT TIME ZONE 'America/Los_Angeles' AS "End Time",
        e1.name AS "Event Name"
FROM event AS e1
JOIN event AS e2 ON e1.event_dt && e2.event_dt AND e1.id != e2.id
ORDER BY "Start Time";
```{{execute}}

>**Note:**
>
>In this scenario, we haven't specified a business rule that no events can 
overlap. We can enforce such a rule with an EXCLUDE constraint -- which is 
discussed in [this course](../constraints/).

### Links to official documentation

[postgresql.org: Range Types](https://www.postgresql.org/docs/current/rangetypes.html)  
[postgresql.org: Range Functions and Operators](https://www.postgresql.org/docs/current/functions-range.html)
