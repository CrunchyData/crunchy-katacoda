You'll sometimes find that a set of data has to go to multiple tables in the 
database, but there could be parent-child relationships between some of these 
tables. ("Parent-child" is another way to describe a relationship in which one 
table has a primary key that is stored as a foreign key in another table. The 
"child" table, with the foreign key, _inherits_ an attribute from the 
"parent" table with the primary key.) This means that in order to add a row to 
a child table, you would need data from the parent table. 

For example, if a person isn't currently in the database and registers for an 
Extra Mile event for the first time, their registration data may have to go 
to the client, attendance, and payment tables. But how do we add new rows to 
the attendance or payment tables if their record in the client table hasn't 
been created and we don't know the `id` value yet?

### INSERT ... RETURNING

The basic INSERT statement doesn't give any return values when executed (it 
just displays a message that says how many rows were inserted). Technically, 
you could run another query that selects the data you need from 
the row that was just inserted. But the RETURNING clause allows you to bypass 
that extra query - the INSERT _can_ return values that you could then use right
 away for subsequent operations.

```
INSERT INTO client (first, last, email, career_interests)
VALUES ('Jermayne', 'Frankum', 'jfrankum7@latimes.com', '{"Developer", "Engineering Manager"}')
RETURNING (id);
```{{execute}}

The result with RETURNING is the same as if you had run a SELECT statement. So,
 the following also works as if you had selected all columns:

```
INSERT INTO client (first, last, email, career_interests)
VALUES ('Bartlett', 'Butterfill', 'bbutterfill1@ask.com', '{"Enrollment Management", "Student Life", "University Relations", "College Athletics"}')
RETURNING *;
```{{execute}}

You'll recall that we didn't include an `id` value in the INSERT because it's 
generated for us. The RETURNING clause can be very useful for working with 
identity or sequence values where they may not exist prior to an INSERT, but you 
need to use them immediately after they're generated. 

In the examples above, if our application makes a call to insert new rows to 
the client table, we can get any value from those rows back in the response.
 We could then use the return values to update or insert to the attendance 
and payment tables, or display a confirmation message to the user - whatever 
we decide needs to happen next.  

The exact way in which you would use the RETURNING result will vary based on 
the programming languages or frameworks you're working with and the [drivers](https://www.postgresql.org/download/products/2-drivers-and-interfaces/) 
you're using to interface with Postgres. 
