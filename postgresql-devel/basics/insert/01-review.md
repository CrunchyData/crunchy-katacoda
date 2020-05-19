First, we'll take a quick look at our tables that have been populated with data
 about Extra Mile's clients as well as events:

```
SELECT * FROM client;

SELECT * FROM event;
```{{execute}}

Let's review the basic syntax for adding rows using INSERT:

```
INSERT INTO event (name, event_dt, mode)
VALUES ('Test Event', 
        tstzrange('2019-12-14 12:00:00 EST', '2019-12-14 17:00:00 EST', '[)'),
        'Virtual'
);
```

The basic syntax includes:
1. The names of columns to which you're adding data (in parentheses following 
the INSERT INTO)
2. The values that should go in each respective column (in parentheses 
following the VALUES clause)

The exceptions to the above are serial and identity columns. Postgres 
automatically generates these values, so you should not include them in the 
INSERT statement. The event table we're using in this scenario does have 
an identity column (use `\d event` in `psql` to check again), but we're not 
including it in our INSERT. 

(Our [Create Table course](https://learn.crunchydata.com/postgresql-devel/courses/basics/basictable) 
also discusses what happens if you include an insert value for serial and 
identity columns. Don't do it, folks!)

When specifying the column names, it doesn't have to go in the same order as 
in the table, so this works the exact same way as the earlier statement:

```
INSERT INTO event (event_dt, name, mode)
VALUES (tstzrange('2019-12-14 12:00:00 EST', '2019-12-14 17:00:00 EST', '[)'),
        'Test Event',
        'Virtual'
);
```{{execute}}

The order of the values must always match the order of the column names.

#### What happens when a column is omitted?

It depends on whether a default value has been set for that column.

In this scenario, we also have an attendance table (that we did not include as 
an example in the previous scenario, _Advanced Data Types_):

```
\d attendance
```{{execute}}

You'll see that this table has a relationship to both the client and event 
tables. This table tracks what events were attended by which clients, so the 
foreign key references indicate the record on the client table as well as the 
record on the event table.

You'll also see that the column has been set with a default. If we add a new 
row to the table and not specify an `attend_status`:

```
INSERT INTO attendance (client_id, event_id)
    VALUES (3, 5)
;

SELECT * FROM attendance;
```{{execute}}

The default value `'Registered'` is added for the new row.

If **no default value** is explicitly defined for the column, it defaults to 
`NULL`.

#### What about when no list of column names is provided?

In Postgres, it is possible to skip the column list entirely (but all 
columns _must_ be filled), like so :

```
INSERT INTO attendance VALUES (5, 1, DEFAULT);

SELECT * FROM attendance;
```{{execute}}

That said, it is still **good practice** to explicitly specify the column names. 
Someone else could add new columns to the table, so specifying column names 
helps prevent unexpected behavior, like values being added to the wrong column.
 This practice also keeps your database queries clear.
