### 2. \copy to populate new table

We'll now use the `\copy` command to populate `cities`:

```
\copy cities (geonameid, name, asciiname, alternatenames, latitude, longitude, feature_class, feature_code, country_code, cc2, admin1_code, admin2_code, admin3_code, admin4_code, population, elevation, dem, timezone, modification_date) from '/data/cities15000.txt' with (format csv, delimiter E'\t', header false)
```{{execute}}

- Our data file does not have the `id` and `geom` values, so we're not 
including them in the list of columns in `cities (...)`.
- We also use these options in `WITH`:
  - `format csv` - while the file has a .txt extension, `csv` is actually still
   used if the file is "separated" or delimited. In this case, we have a 
   tab-delimited file, but we would still need to use `csv`.
  - `delimiter E'\t'` - we use an [escape string constant](https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS)
   to indicate the tab delimiter.
  - `header false` is used with the `csv` format and indicates that our file 
  does not contain a header row.

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
