### 2. \copy to populate new table

We'll now use the `\copy` command to populate `cities`:

```
\copy cities (geonameid, name, asciiname, alternatenames, latitude, longitude, feature_class, feature_code, country_code, cc2, admin1_code, admin2_code, admin3_code, admin4_code, population, elevation, dem, timezone, modification_date) from '/data/cities15000.txt' with (null '')
```{{execute}}

- Our data file does not have the `id` and `geom` values, so we're not 
including them in the list of columns in `cities (...)`.
- We also use the WITH clause to add the `null ''` option. 

We have a tab-delimited .txt file, so we'd use `text` for our FORMAT parameter 
(which is the default for [`\copy`](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS-COPY)/
[SQL COPY](https://www.postgresql.org/docs/current/sql-copy.html), so we don't need to specify it in
the command). The tab delimiter is also default for `text`. The only option 
we need to explicitly include is `null ''` which indicates that null values 
are represented by empty strings in the file. 

Try running some simple queries against `cities`, such as:

```
\x

SELECT * FROM cities ORDER BY population DESC LIMIT 3;
```{{execute}}

### Good ol' INSERT statements

You can also add spatial data in PostGIS using SQL inserts. If you haven't yet,
 check out our course on [INSERT](https://learn.crunchydata.com/postgresql-devel/courses/basics/insert).
The [official PostGIS docs](https://postgis.net/docs/using_postgis_dbmanagement.html#idm2274) 
has an example on how to use the INSERT syntax to add geometry/geography values
 in their text representation.
