All of the commands on this page should be run within **Terminal 2**.

## `postgisftw` schema

To create a user-defined function, first we must log into the running database.

>**WAIT!** Before you execute the code block below, make sure you've navigated back to ```Terminal 2```. 

```PGPASSWORD="password" psql -h localhost -U groot nyc```{{execute}}

In order for pg_featureserv to publish a user-defined function, we first need to create the schema that pg_featureserv looks for. The schema needs to be called ```postgisftw``` (aka "PostGIS for the Web"). (Note: we are planning to expand the schemas available to pg_featureserv, but for now it is limited to this schema.)

```CREATE SCHEMA postgisftw;```{{execute}}

Now that we've created the schema, we can add our function. But before we do that, let's take a quick look at the data. 

First, let's take a look at what tables we have.

```SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'public' AND schemaname != 'information_schema' ;```{{execute}} 

You can see we have six tables with information about New York City. If you look at the pg_featureserv tab > Collections, those same tables are also available in the pg_featureserv UI. 

### A bit of background on census data

The US Census Bureau is responsible for conducting the census of the US population every 10 years. (We just had one in 2020.) This information is then used by the US government to make all sorts of decisions to regarding the use and dispersment of tax dollars. But did you know they also make all this information publicly available? You can download this data and use it for your own analysis. 

The query in the function below could potentially be the first step in determining the population demographic (i.e. age, race, gender, etc) around certain subway stops within a walking radius. You could then add additional queries to further analyze the data (i.e. median household income in the area, time table of when the subway stops, peak rush hour traffic, etc)

Now, let's go back to the **Terminal 2** tab, and we'll take a quick look at one of the tables we'll use in the function.

```SELECT DISTINCT * FROM public.nyc_subway_stations ORDER BY name ASC LIMIT 10;```{{execute}}

You can see there is a variety of data in the table, but we will only use a subsection of this table and the US Census Block table. Now, let's get back to the function.

## Create a user-defined function

We'll create a new function named `postgisftw.nyc_katacoda`.

This function does a query aganist US Census Block borough names, and returns the name of the borough and Census Block geometries that intersect with the subway geometry.

```
CREATE or REPLACE FUNCTION postgisftw.nyc_katacoda(stop_name character varying DEFAULT 'Bronx Park East')
RETURNS TABLE (borough_name character varying, geom geometry)
AS $$
BEGIN
RETURN QUERY
SELECT a.boroname, a.geom 
FROM nyc_census_blocks a, nyc_subway_stations t
WHERE t.name= stop_name
AND ST_Intersects(ST_Buffer(a.geom,30),t.geom);
END;
$$
PARALLEL SAFE
STABLE
LANGUAGE plpgsql;
```{{execute}}

Now if you return to the pg_featureserv tab, you can look under the Functions page and you'll see your newly created function.

To show that it's live, go back to **Terminal 2** and let's get some station names from our subway stations table:

```SELECT DISTINCT name FROM public.nyc_subway_stations
ORDER BY name ASC LIMIT 30;```{{execute}}

Try grabbing one of these names (e.g. `14th St`), and in the pg_featureserv UI, enter that name in the ```stop_name``` Function Args field on the `nyc_katacoda` function view. (Click `Requery` to view the output geometries.)
