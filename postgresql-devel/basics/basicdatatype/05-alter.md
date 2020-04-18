## Using the `ALTER` command to change data types

As mentioned earlier, after a table column's data type has been set, it is 
still possible to change it.  

The main thing to note when changing data types for tables with existing data 
is that it can also change the data itself!

Let's see what happens when we change the `number2` column in `numtable` to the data type `real`:

```
ALTER TABLE numtable
ALTER COLUMN number2 SET DATA TYPE real;

SELECT * FROM numtable;
```{{execute}}

The value `2.75314769` got rounded up to `2.75315`. It may seem insignificant in this example, but not when your business case demands exactness in numbers. You could also have some functions, procedures, or views that no longer work as expected; there could be existing constraints on the column to be altered that may also cause unexpected results due to the change in type, so you may need to make sure those are updated as well.

So, use caution when changing data types. Depending on the extent of data affected, or other dependencies involved, there might be better practices than just directly changing a column data type.
