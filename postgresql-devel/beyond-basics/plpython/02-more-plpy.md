Example of function that uses standard Python module




Example of function that uses an external lib eg. numpy? (Break out into separate page if 
setup is very involved)

placeholder:

`docker exec --user root -it pgsql bash`

`pip3 install numpy`

`psql -U groot -h localhost workshop`

```
CREATE OR REPLACE FUNCTION testnp ()
RETURNS TEXT[]
AS $$
    import numpy as np
    a = np.arange(15).reshape(3, 5)
    return a
$$ LANGUAGE 'plpython3u';
```{{execute}}