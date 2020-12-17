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

Running the `psql` command `\dt` shows that we don't have any database tables. 
On top of that, we get an error `function postgis_full_version() does not 
exist`. The reason is that even though PostGIS is installed, we actually need 
to load the extension in the databases in which we want to use it. We hadn't 
done that yet for the `tampa` database. Let's go ahead and do that now (note 
that `CREATE EXTENSION` can generally only be executed by admins/superuser 
roles).

```
CREATE EXTENSION postgis;
```{{execute}}

And now when we check the PostGIS version: `SELECT PostGIS_Full_Version();`{{execute}} 
we should see the same information displayed as with `workshop` earlier.
 
Let's run the `\dt` again:

```
\dt
```{{execute}}

We see that we now also have the `spatial_ref_sys` table.

We're now ready to import spatial data. Click "Continue" and we'll learn about 
importing spatial data using `shp2pgsql`.
