There are several numeric types available in Postgres. They differ from each 
other with respect to numeric range and storage size (for integers), or 
precision (for decimals).

As in any other programming language, defining a type as numeric (as opposed to
 character/text) allows you to perform mathematical operations on stored values.

### Integers

The following character types store whole numbers:

| Name | Description | Range | Storage Size  |
|---|---|---|---|
| smallint  | small-range integer  | -32768 to +32767  | 2 bytes   |
| integer  |   | -2147483648 to +2147483647  | 4 bytes  |
| bigint  | large-range integer  | -9223372036854775808 to +9223372036854775807  | 8 bytes  |

`integer` is most commonly used, with `bigint` being used when the `integer` 
range is too small.

Serials (`smallserial`, `serial`, `bigserial`) are not _true_ types in the 
sense that they're shorthand notation, telling Postgres that the column is an 
`integer` type, and to then create a unique identifier that _autoincrements_. 
This is a Postgres-specific method. Another way to accomplish this result that 
is in standard SQL is to use an [_identity_ column](https://www.postgresql.org/docs/current/sql-createtable.html).  

### Numeric vs. decimal vs. real...

Use `numeric` with non-whole numbers, where **exactness** is required. Here's 
the syntax for declaring this type:

```
NUMERIC(precision, scale)
```

* `precision` is a positive integer that specifies the total count of digits in
 the number, including numbers on both sides of the decimal.

* `scale` is either 0 or a positive integer that indicates the count of digits to the right of the decimal.

Declaring `NUMERIC` without a specified precision nor scale will allow the column to store values of any precision and scale.

`decimal` is functionally the same as `numeric` in Postgres, and are both part 
of the SQL standard. 

The `real` and `double precision` types are **approximate** numeric types. This means that storing and outputing a value might show slight discrepancies.

### Add numeric values to a table

Let's try creating a new table with numeric columns and populate it with a few 
values:

```
CREATE TABLE numtable (
    id serial,
    number1 integer, 
    number2 numeric(16,8)
);

INSERT INTO numtable (number1, number2)
VALUES  (55, 110),
        (202004, 40.200),
        (1510, 33.6),
        (4132, 2.75314769)
;

SELECT * FROM numtable;
```{{execute}}

You'll see that some of the values under `number2` were _coerced_ to the 
indicated scale.

### Try a mathematical operation

Let's try to multiply two values from `texttable`:

```
SELECT 
    (SELECT chara1 FROM texttable WHERE id = 1) 
    * (SELECT chara1 FROM texttable WHERE id = 2)
;
```{{execute}}

The error message we get back implies that the operation isn't allowed for that
 data type (`char`).

But if we try it with numeric values from `numtable`:

```
SELECT 
    (SELECT number1 FROM numtable WHERE id = 1) 
    * (SELECT chara1 FROM numtable WHERE id = 2)
;
```{{execute}}

We do get a numeric value as a result:

```
---------
11110220
```

### Note on numerics

There are storage and performance implications with numeric data types. For 
instance, calculations on `numeric` are slower than on the floating-point types
 `real` and `double precision`. But as mentioned earlier, floating-point types 
 don't guarantee exactness. You'll have to understand your data storage and 
 processing needs and weigh your options for numeric types carefully.
