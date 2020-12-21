More common ways of using `shp2pgsql` would be either one of the following two steps.

### 1. Redirect shp2pgsql output to a SQL file

We have a shapefile in our /data/tpa/ directory that contains data about 
[parking garages and lots](https://city-tampa.opendata.arcgis.com/datasets/parking-garages-and-lots)
 throughout downtown Tampa. We'll use `shp2pgsql` to first save the output in a SQL script,
  then use `psql` to run the script.

```
shp2pgsql -s 4326 -I /data/tpa/Parking_Garages_and_Lots.shp > parking_garages_lots.sql
```{{execute}}

1. By default, a new table `parking_garages_and_lots` is created and populated 
from the shapefile. This table will include a `geom` column.
2. `-s 4326`: the SRID `4326` (WGS 84) is set for the `geometry` column.
3. `-I` creates a [GiST index](https://www.postgresql.org/docs/current/gist-intro.html)
 on `geometry`.
4. `/data/tpa/Parking_Garages_and_Lots.shp` is our source file.
5. `>` is an output redirection operator in *nix systems. We'll get the SQL 
output from `shp2pgsql` written to a file called `parking_garages_lots.sql`.

Let's take a look at the script:

```
nano parking_garages_lots.sql
```{{execute}}

Outputting to a file is useful not only for checking to see what the generated SQL is.
 You can also make any desired changes to the script before running it. 
 (Exit out of `nano` by hitting Ctrl + O to save changes you make, then Ctrl + X.)

When you're ready to import the data, run this `psql` statement:

```
psql -U groot -h localhost -d tampa -f parking_garages_lots.sql
```{{execute}}

We are logging in again as `groot` this time and not `postgres` -- remember 
that the superuser role should only be used when really needed.

The `-f` flag tells `psql` to [read commands](https://www.postgresql.org/docs/current/app-psql.html) 
from the given file. (We have a course on [loading data into Postgres](https://learn.crunchydata.com/postgresql-devel/courses/basics/import) if you want a bit more practice with `psql -f`.)

Let's log in to Postgres and try querying our new table:

```
psql -U groot -h localhost tampa
```{{execute}}

Note that when you see "More" in the results, you can hit the spacebar to 
keep scrolling, or `q` to return to the psql prompt.

```
\d parking_garages_and_lots
```{{execute}}
```
SELECT spacename, fulladdr FROM parking_garages_and_lots;
```{{execute}}
