## Use a standard Python module

Python comes with a number of built-in modules, and they can be used in 
PL/Python as well. 

For the following example, we'll use the [**`random`** module](https://docs.python.org/3/library/random.html#module-random).
 `random` includes functions that generates random numbers or elements.

```
CREATE OR REPLACE FUNCTION test_rand (low int, high int)
RETURNS INT
AS $$
    import random
    number = random.randint(low, high)
    return number
$$ LANGUAGE 'plpython3u';
```{{execute}}

* We can import this built-in module with `import random`, just like we 
normally would in Python.
* We name our user-defined function `test_rand`. It accepts two parameters — 
`low` and `high`, both integers — and also returns an integer. 
* `randint()` is a function in `random` that returns a random integer between a specified range. In our function, `low` and `high` are the lower and upper ends of this range.

We can call our new function like so:

`SELECT test_rand(5, 1510);`{{execute}}

Feel free to execute the statement above as many times as you like to check 
that the function does indeed return a random number each time. You can try calling the function and passing in different arguments as well. 

**Something to think about:** How would you implement the same function in plain SQL?
 Do you find it easier to accomplish the same result?

## Import a Python library

PL/Python can take advantage of external Python libraries as well. However, 
unlike built-in modules such as `random`, you would need to install the packages on the same machine as Python.

We'll use [NumPy](https://numpy.org/) in this example. NumPy is one of the most popular libraries in Python and is widely used for scientific computing.

First, we'll need to log out of Postgres. 

`\q`{{execute}}

We're now back in the terminal, but since we're in a containerized environment,
 we'll actually need to open up the shell (as root user) on the container so we can install NumPy:

`docker exec --user root -it pgsql bash`{{execute}}

In the shell, we use pip3, a version of the [pip installer](https://pip.pypa.io/en/stable/) for Python 3, 
to install the package.

`pip3 install numpy`{{execute}}

Let's exit the shell, and log back in to Postgres as `groot` (password: `password`):

`exit`{{execute}}

`psql -U groot -h localhost workshop`{{execute}}

Finally, let's go ahead and create our PL/Python function that uses NumPy. 
We'll just use the same example found in the NumPy [Quickstart tutorial](https://numpy.org/doc/stable/user/quickstart.html):

```
CREATE OR REPLACE FUNCTION testnp ()
RETURNS int[][]
AS $$
    import numpy as np
    a = np.arange(15).reshape(3, 5).tolist()
    return a
$$ LANGUAGE 'plpython3u';
```{{execute}}

* We name our function `testnp`. It does not take in any input.
* The function returns a two-dimensional [array](https://www.postgresql.org/docs/current/arrays.html) of integers. 
* With NumPy installed in the container, we can `import numpy` as per usual.
* [`arange()`](https://numpy.org/doc/stable/reference/generated/numpy.arange.html)
 is a NumPy function that returns evenly spaced values within a given interval.
  In this case, 0 is the start value, and 15 is the end value (exclusive). 
  `reshape()` is a function that "transforms" a given array to specified 
  dimensions (two in this case: the outer array has 3 elements, while the inner
   arrays each have 5 elements). 
* Finally, we use the NumPy [`ndarray.tolist()` method](https://numpy.org/doc/stable/reference/generated/numpy.ndarray.tolist.html) to convert the two-dimensional array into a Python list. Why? For PL/Python to return a SQL array, the function must [return a Python list](https://www.postgresql.org/docs/10/plpython-data.html#PLPYTHON-ARRAYS).

Now, let's try calling our new function:

`SELECT testnp();`{{execute}}

You should get a two-dimensional array where the elements are within the range 
of 0 to 15 (exclusive).

`{{0,1,2,3,4},{5,6,7,8,9},{10,11,12,13,14}}`
