## Use a standard Python module

Python comes with a number of built-in modules, and they can be used in 
PL/Python as well. 

For the following example, we'll use the [**`random`** module](https://docs.python.org/3/library/random.html#module-random).
 `random` has a number of functions that random numbers or elements.

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
* We name our user-defined function `test_rand`. It accepts two parameters, 
`low` and `high`, both integers, and also returns an integer. 
* `randint()` is a function in `random` that returns a random integer between a specified range. In our function, `low` and `high` are the lower and upper ends of this range.

We can call our new function like so:

`SELECT test_rand(5, 1510);`{{execute}}

Feel free to execute the statement above as many times as you like to check 
that the function does indeed return a random number each time. You can try calling the function and passing in different arguments as well. 

**Something to think about:** How would you implement the same function in SQL?
 Is it easier to accomplish the same task?

## Import a Python library

PL/Python can take advantage of external Python libraries as well. However, 
unlike built-in modules like `random`, you would need to install the packages on the same machine as Python.

We'll use [NumPy](https://numpy.org/) in this example. NumPy is one of the most popular libraries in Python and is widely used for scientific computing.

First, we'll need to log out of Postgres. 

`\q`{{execute}}

We're now back in the terminal, but since we're in a containerized environment,
 we'll actually need to open up the shell on the container so we can install NumPy.

`docker exec --user root -it pgsql bash`{{execute}}

In the bash shell, we use pip3, a version of the pip installer for Python 3, 
to install the package.

`pip3 install numpy`{{execute}}

Let's log back in as `groot` (password: `password`):

`psql -U groot -h localhost workshop`{{execute}}

Finally, let's go ahead and create our PL/Python function that uses NumPy. 
We'll just use the same example found in the NumPy [Quickstart tutorial](https://numpy.org/doc/stable/user/quickstart.html):

```
CREATE OR REPLACE FUNCTION testnp ()
RETURNS int[]
AS $$
    import numpy as np
    a = np.arange(15).reshape(3, 5)
    return a
$$ LANGUAGE 'plpython3u';
```{{execute}}

* We name our function `testnp`. It does not take in any input.
* The function returns an array of integers. 
* With NumPy installed in the container, we can `import numpy` as per usual.
* [`arange()`](https://numpy.org/doc/stable/reference/generated/numpy.arange.html)
 is a NumPy function that returns evenly spaced values within a given interval.
  In this case, 0 is the start value, and 15 is the end value (exclusive). 
  `reshape()` is a function that "transforms" a given array to specified 
  dimensions. 

