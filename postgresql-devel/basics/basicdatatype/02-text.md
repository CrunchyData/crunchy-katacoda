Postgres has three built-in character types:

* `character` (or `char`) - fixed length
* `character varying` (or `varchar`) - variable length with limit
* `text` - variable unlimited length

Declaring a `char` or `varchar` type when creating a new table looks like this:

```
CREATE TABLE texttable (
    id serial, 
    chara1 char(8), 
    chara2 varchar(32))
;
```{{execute}}

(We'll look at the `serial` type in the next step.)

The `n` in `char(n)` and `varchar(n)` must be a positive integer, and 
represents the maximum number of characters in the string. More than the 
maximum will cause an error when attempting to save, unless the excess 
characters are spaces.

If the `n` isn't specified for `char`, it is interpreted as `char(1)`. If the 
`n` isn't specified for `varchar` it will store strings of any length (as does 
`text`).

For `char`, the string is padded up to n characters if the length is shorter 
than n. For `varchar`, strings shorter than n are stored as is.

### Add text values to a table

Let's try adding a few rows of values:

```
INSERT INTO texttable (chara1, chara2)
VALUES  ('55', 'Blue'),
        ('202004', 'Lavender'),
        ('1510', 'Magenta'),
        ('4132', 'Blue, Lavender, Magenta, Emerald')
;

SELECT * FROM texttable;
```{{execute}}

### Which character type to use

The `text` type in Postgres is not part of the SQL standard.

There are generally no substantial differences in performance between `char`, 
`varchar`, or `text`. `text` and `varchar` are more commonly used and 
preferred. (A constraint can be added to limit the number of characters for 
`text`.)
