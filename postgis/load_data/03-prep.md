Before any spatial data is loaded into PostgreSQL, we need a spatial database. 
This means that the PostGIS extension has been loaded for that particular 
database. We have PostGIS installed in this environment, so let's do a check 
by logging in to Postgres via the terminal prompt as superuser (`postgres` with
 password `password`):

```
psql -U postgres -h localhost tampa
```{{execute}}

If we execute the following statement within the `psql` shell:

```
\dt

SELECT PostGIS_Full_Version();
```{{execute}}

Running the `psql` command `\dt` shows that we don't have any relations or database tables yet. 
On top of that, we get an error `function postgis_full_version() does not exist`. 
The reason is that even though PostGIS is installed, we actually need 
to load the extension in the databases in which we want to use it. We hadn't 
done that yet for the `tampa` database, so let's go ahead and do that now. (Note 
that `CREATE EXTENSION` can generally only be executed by admins/superuser 
roles).

```
CREATE EXTENSION postgis;
```{{execute}}

And now when we run `SELECT PostGIS_Full_Version();`{{execute}} 
we can see a string containing the PostGIS version number in this database (2.5.4).
 
Let's run `\dt` again:

```
\dt
```{{execute}}

Great! We now also have the `spatial_ref_sys` table.

We're now ready to import spatial data into our current database. The first tool 
we'll learn about is `shp2pgsql`.
