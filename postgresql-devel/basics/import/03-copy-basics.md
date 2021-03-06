Often, instead of using a script you may need to import from a 
data file, and that file may contain thousands or even millions of rows of 
data. In this case, we can use the Postgres [COPY](https://www.postgresql.org/docs/current/sql-copy.html) utility to easily handle this 
type of bulk data import.  

## The MoMA Artists dataset

The Artists dataset from the MoMA Collection Data (DOI: [10.5281/zenodo.4009955](http://dx.doi.org/10.5281/zenodo.4009955))
 is available in both CSV and JSON format and contains 15,236 records of artists that have 
 been catalogued in the museum's database. It includes basic data about each 
 artist (e.g. name, nationality, gender) and also some metadata such as [Wiki QID](https://en.wikipedia.org/wiki/Wikidata)
  and [Getty ULAN ID](https://www.getty.edu/research/tools/vocabularies/ulan/about.html).


We'll use the CSV file, which we've already added to this environment 
under a directory called `data`. Taking a quick look at the beginning contents of the file:

```
\q
head /data/artists.csv
```{{execute}}

## 1. Create the table to store the data

The dataset does have a `constituent_id`, but we'll store that in its own 
column while we generate our own `id` value.

```
psql -U groot -h localhost workshop
```{{execute}}
```
CREATE TABLE artists (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    constituent_id INTEGER UNIQUE NOT NULL,
    display_name TEXT,
    artist_bio TEXT,
    nationality TEXT,
    gender TEXT,
    begin_date smallint,
    end_date smallint,
    wiki_qid text,
    ulan int
);
```{{execute}}

## 2. psql `\copy`

We're already logged in to Postgres via `psql`, so let's run this command to 
import the dataset:

```
\copy artists (constituent_id, display_name, artist_bio, nationality, gender, begin_date, end_date, wiki_qid, ulan) from '/data/artists.csv' WITH CSV HEADER QUOTE '"'
```{{execute}}

We include the following [arguments](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS-COPY) with the `\copy` meta-command:

- The name of the table we want to load data to: `artists` 
- The column names in the data table that will accept the data, in order: 
`(constituent_id, ..., ulan)`. There are some instances in which the column 
list can be omitted (e.g. if the file layout matches the table structure 
exactly) but it's generally better practice to specify it.
- The absolute path of the file we're loading: `/data/artists.csv`  

As well as the following options after `WITH`:
- `CSV` for the file format
- `HEADER` to indicate there is a header row
- `QUOTE '"'` to indicate the quoting character if any values are quoted

The COPY command tag (which you see after the process completes) will indicate the number of rows copied.

Let's issue a few queries against our table data:

```
SELECT * FROM artists LIMIT 5;
```{{execute}}

```
SELECT count(*) FROM artists WHERE nationality != 'American';
```{{execute}}

```
SELECT gender, count(*) FROM artists GROUP BY gender;
```{{execute}}

## SQL `COPY` vs. psql `\copy` 

You may notice that the `\copy` information in the Postgres docs says that the 
syntax is similar to the [COPY command](https://www.postgresql.org/docs/current/sql-copy.html).
 There are still key differences between the two:

1. `\copy` is **"client-side"** whereas `COPY` is **"server-side"**: `psql` the command line utility executes the `\copy` command, but for `COPY` it's actually the Postgres server.
2. `\copy` doesn't require Postgres superuser privileges and instead takes on 
the execution privileges of the local user (the environment running 
`psql`). Meanwhile, `COPY` requires the role issuing the command to have read 
permissions to copy from a file.  
In fact, if you try running this command in terminal again you should encounter
 the relevant error:

```
COPY artists (constituent_id, display_name, artist_bio, nationality, gender, begin_date, end_date, wiki_qid, ulan) FROM '/data/artists.csv' WITH CSV HEADER QUOTE '"';
```{{execute}}
>`ERROR:  must be superuser or a member of the pg_read_server_files role to COPY from a file`

Additional Notes:  
1. If a column is not included in the list to be copied to, the column will be populated with its default value.
2. Sometimes you'll need to do some cleanup before the data is imported in its 
"final" form to the desired table. In addition to directly manipulating the 
file, you can also create temporary or "staging" tables where you can do some intermediary 
work, and then insert the values to the final table from the intermediate table when ready. 
3. For an example on importing JSON using COPY, check out this Crunchy [blog post on fast CSV and JSON ingestion](https://info.crunchydata.com/blog/fast-csv-and-json-ingestion-in-postgresql-with-copy).
4. Using the `COPY` command to load data server-side can run a lot faster than running `\copy` on a client. Server-side `COPY` avoids network latency. When you are the database’s administrator and can place files on the server, `COPY` excels at bulk loading.
5. `\copy` or `COPY` can also be used to export data.

>COPY is a [driver level](https://www.postgresql.org/docs/current/libpq-copy.html) capability in Postgres, so your applications may be able to utilize it as well. However you use COPY--psql, your app, server-side--it’s the **preferred and fastest way** of bulk importing data into Postgres.
