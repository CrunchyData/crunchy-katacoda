As mentioned earlier, after a table column's data type has been set, it is 
still possible to change it.  

A change in business requirements might prompt you to consider making changes 
to data types. Or perhaps you run some audits and need to look into using a 
different type to minimize errors or increase performance. While you may not 
necessarily be the one to implement these kinds of schema changes (it could 
be someone who is, for example, specifically in a DBA role), it's always 
helpful for you as a developer to be aware of some possible scenarios that 
might affect your work.

You can read a bit more on modifying database tables in the [official docs](https://www.postgresql.org/docs/current/ddl-alter.html).

The main thing to note when changing data types for tables with existing data 
is that it can also change the data itself (or cause data loss entirely)!

Let's see what happens when we change the `number2` column in `numtable` to the
 data type `real`:

```
ALTER TABLE numtable
ALTER COLUMN number2 SET DATA TYPE real;

SELECT * FROM numtable;
```{{execute}}

The original value `2.75314769` got rounded up to `2.75315`. It may seem 
insignificant in this example, but not when your business case demands 
exactness in numbers. You could also have some functions, procedures, or views 
that no longer work as expected; there could be existing constraints on the 
altered column that may also cause unexpected results because of the change in 
type, so you may need to make sure those are updated as well.

Depending on the extent of the data affected, or other dependencies involved, 
there may be better practices than just directly changing a column data type. 
(One option is to create a new column and "migrate" the existing data to the 
new column, making sure to carry out the appropriate casting or conversion.)

Making database schema changes is an entire topic in itself. There are a lot of
 complexities to think about. The main takeaway is: changing data types or 
 carrying out other database alterations isn't as easy as merely running the 
 ALTER command! 
