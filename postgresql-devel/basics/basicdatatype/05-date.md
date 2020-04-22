Postgres also has several options for storing date/time. 

Before we dive in, let's create another table and add in a few values:

```
CREATE TABLE timetable (id serial PRIMARY KEY, 
                        dt_column timestamptz, 
                        now_column timestamptz(3), 
                        in_column interval
);

INSERT INTO timetable (dt_column, in_column)
VALUES  ('2020-04-15 13:00 PST', '1 day'),
        ('2020-01-01 08:30:15.20', '1 week'),
        (current_timestamp, '1 month')
;

SELECT * FROM timetable;
```{{execute}}

The different date/time types are:

* `date` - stores only the date, with no time of the day
* `time` - stores only the time of day without the date
* `timestamp` - stores both the date and time
* `interval` - stores an interval of a specified measure or range of time, and 
is useful for _relative_ times

These types can be defined with _options_:

* `with time zone` (`time` and `timestamp` only): `timestamptz` (which we used 
in the new table above) is Postgres shorthand for `timestamp with time zone`. 
There's several different ways to explicitly include the time zone for an input
 value - for example, by abbreviations such as `EST` and `PST`, by using an 
 _offset_ that indicates the number of hours difference from Coordinated 
 Universal Time (UTC), or by using an area and location such as 
 `America/New_York`. 

    The value stored internally in Postgres for timezone-aware dates and times 
    is in UTC, so if an input value has a time zone, it is converted to UTC 
    using the offset for the included time zone. If a time zone is not 
    included, it is associated with the `TimeZone` parameter, which 
    you can check by running:

    ```
    SHOW TIMEZONE;
    ```{{execute}}  

    This environment's `TimeZone` is in UTC, so you'll see that the inserted 
    values for rows 2 and 3 indicate a "+00" offset. Row 3 in particular has 
    also been converted in UTC.

    Note that the _server_ timezone can be different from the _session_ 
    timezone. Timezones in general are a pretty complex topic, and we'd 
    recommend diving into more resources such as the [official docs](https://www.postgresql.org/docs/current/datatype-datetime.html#DATATYPE-TIMEZONES) to learn about the nuances.

    >While `timestamp` by itself (that is, `timestamp without timezone`) is 
    technically valid, it can cause a lot of issues and so it's recommended to 
    always 

* _precision_ (`time`, `timestamp`, and `interval` only): an integer from 0 to 
6 that indicates what fraction (up to the microsecond) the time value should be
 stored. If the precision isn't specified, the default precision is 6 (i.e. to 
 the microsecond).

    In `timetable`, the third row stored the microsecond part of the time value 
    under `dt_column`.

    If we add a new value under `now_column` which has a precision of 3, we'll see 
    how the fraction differs from `dt_column`:

    ```
    UPDATE timetable
    SET now_column = now()
    WHERE id = 1;

    SELECT * FROM timetable;
    ```{{execute}}

    `current_timestamp` is a SQL standard function that provides the current date 
    and time. `now()` is a Postgres function that is equivalent to 
    `current_timestamp`.


### Intervals

Intervals come in handy when you need to know or derive a _relative_ time.

Let's say we use the `in_column` on `timetable` to calculate a date/time value 
relative to `dt_column`:

```
SELECT 
    dt_column,
    in_column,
    dt_column + in_column AS future_dt_column
FROM timetable;
```{{execute}}

Some use cases for intervals are mailing campaigns (a series of timed mailings 
going out to a group of recipients), or keeping track of when customers are due
 to renew subscriptions.
