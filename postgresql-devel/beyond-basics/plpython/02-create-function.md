Now that PL/Python has been made a trusted language in our development 
environment, we can log out as `postgres` and log in as our user `groot` and 
start writing functions:

`\q`{{execute}}

`psql -U groot -h localhost workshop`{{execute}}

Our first function will include just a couple of lines of basic Python:

```sql
CREATE OR REPLACE FUNCTION two_power_three ()
RETURNS VARCHAR
AS $$
    result = 2**3
    return f'Hello! 2 to the power of 3 is {result}.'
$$ LANGUAGE 'plpython3u';
```{{execute}}

* We name our function `two_power_three`
* The function does not accept any parameters, indicated by `()`
* The function returns a character string
* Everything in between the two `$$` is the actual Python code
* We indicate that the function uses `plpython3u`, or Python 3

Now, let's call our new function:

`SELECT two_power_three ();`{{execute}}

And it should return the following string: `Hello! 2 to the power of 3 is 8.`

Next, let's try doing something a little more interesting: using Python modules and libraries.
