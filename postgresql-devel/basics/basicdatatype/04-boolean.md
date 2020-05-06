Booleans in Postgres can store three "states": true, false, and unknown, 
represented by the NULL value.

In Postgres, the `boolean` (or `bool` for short) type can accept different 
literal representations for true and false, including but not limited to:

| True  | False  |
|---|---|
| `true`*  | `false`*  |
| `'1'`  | `'0'`  |
| `'yes'`  | `'no'`  |
|  `'y'` | `'n'`  |
| `'on'`  | `'off'`  |

*true and false can also be enclosed in quotes.

Postgres also accepts _prefixes_ of the strings `'true'`, `'yes'`, 
`'false'`, and `'no'`, such as `'y'` and `'n'` (as seen above), `'t'`, `'tr'`, 
`'f'`, `'fa'`, etc.

### Add boolean values

Let's create another table:

```
CREATE TABLE booltable (
    id serial PRIMARY KEY,
    boolcol bool
);

INSERT INTO booltable (boolcol)
VALUES  ('1'),
        (true),
        (false),
        ('f'),
        (NULL),
        ('1'),
        (NULL)
;
```{{execute}}

The output for `boolean` is either `t` or `f`:

```
SELECT * FROM booltable;
```{{execute}}

### Querying booleans

We'll get more into querying and operators in later courses, but for now, the 
important thing to remember about querying the `boolean` type is that `NULL` 
is a representation of an _unknown_ or _missing_ (neither true nor false!) 
value. Let's take for example:

```
SELECT * FROM booltable WHERE boolcol = NULL;
```{{execute}}

And compare that with the following query:

```
SELECT * FROM booltable WHERE boolcol IS NULL;
```{{execute}}

In the first query, we're _comparing_ to `NULL`, but unknown values cannot be 
equal nor not equal to `NULL`, so no rows are returned.

So, if you need to find null or not null values, use the expressions `IS NULL` 
or `IS NOT NULL`.
