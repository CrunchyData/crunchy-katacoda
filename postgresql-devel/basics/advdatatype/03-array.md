### A few helpful functions

#### `unnest()`

Instead of returning the array elements within the same row, you can use 
`unnest()` to expand the array to multiple rows:

```
SELECT 
    first,
    last,
    unnest(career_interests)
FROM client;
```{{execute}}

`unnest()` returns a [set](https://www.postgresql.org/docs/current/xfunc-sql.html#XFUNC-SQL-FUNCTIONS-RETURNING-SET).
 Each element gets one row, and the data type for each value matches the 
 original type (in this case, `text`).

`unnest()` also opens up the door for working further with the array values; 
for example, querying using wildcards:

```
SELECT first, last, interest 
FROM (SELECT    first, 
                last, 
                unnest(career_interests) as interest
    FROM client) c 
WHERE interest LIKE '%Programming';
```{{execute}}

#### `ANY()`

You may wish to find records that have a specific career interest. The 
[`ANY()`](https://www.postgresql.org/docs/current/functions-comparisons.html#id-1.5.8.28.16) 
function lets you search arrays:

```
SELECT 
    first,
    last,
    career_interests
FROM client
WHERE 'Developer' = ANY(career_interests);
```{{execute}}

>**Note**:
>
>It is possible to index array columns. Indexing is beyond the scope of this 
course, but you'll likely look into a [GIN index](https://www.postgresql.org/docs/current/gin.html) 
for arrays.

#### `array_to_string()`

Postgres functions can help with processing and formatting array data. For 
example, `array_to_string()` takes in an array, a delimiter, and an optional 
null string as arguments, and concatenates the array elements into `text`.

```
SELECT
    first,
    last,
    array_to_string(career_interests, ' | ') 
FROM client;
```{{execute}}

### Update an array

You can modify an entire array or part of an array (by individual element, or slice).

To replace an entire array:

```
UPDATE client
SET career_interests = '{ "Product Management", "UX" }'
WHERE id = 3;

SELECT * FROM client;
```{{execute}}

You can push a new element to either the beginning or end of the array using 
the `array_prepend()` or `array_append()` functions. Alternatively, the 
concatenation (`||`) operator lets you push a single element or another array 
to the existing array as well:

```
UPDATE client
SET career_interests = career_interests || ARRAY['Personal Coaching', 'Community Management']
WHERE id = 4;

SELECT * FROM client;
```{{execute}}

### So when should I use the array type?

It comes down to how you'll be working with the data. While you are able to 
search arrays for individual elements, and indexing can help speed up that 
operation, it might be more efficient to store the data in separate lookup 
tables instead.

The array type would be more suitable if you mostly plan on processing, 
analyzing or reporting on these values as an aggregate, or perhaps if you're 
expecting thousands of elements.

### Links to official documentation

[postgresql.org: Arrays](https://www.postgresql.org/docs/current/arrays.html)  
[postgresql.org: Array Functions and Operators](https://www.postgresql.org/docs/current/functions-array.html)
