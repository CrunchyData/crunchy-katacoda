While having a database running is nifty and all - it's not much fun unless we add some tables and data.
Let's quickly add the tables and data to our "workshop" database. We are basically loading data for U.S. 
Counties - a sub-state (province) geographic subdivision. We chose U.S. data because so much of it is 
freely available and released under a permissive license. 

All the data and SQL used in the following pieces are found in /data/crunchy_demo_data in your vm.

## Loading Geographies

Let's go ahead and load the U.S. County boundaries into a spatially enabled table.


#### Table definition

To see the Data Definition Languague (DDL) SQL for creating  the table. We will use the simple _nano_ editor 
to look at the file.  

```nano /data/crunchy_demo_data/boundaries/county_boundaries.dd.sql```{{execute}}

Typically with a postgis table you would have to make sure you loaded the postgis extension into your database, but in 
this case, when the container was spun up and created the database for you it already added the extension. 

You will also see that at the _CREATE TABLE_ statement we have two geometry columns, one for point data and one for 
polygon data. The 4326 is the coordinate system (the projection and datum) for the coordinates we are storing. Projections 
are a much larger topic then we have time for today - but simply put, they are how we store coordinates that account for 
the shape of the earth. 4326 is the coordinate system you would use with coordinates coming from the GPS on a cell phone.

You will also notice we create _GIST_ index on the geometry columns. The _GIST_ index allows for fast searches when 
performing spatial operations, such as is this point in this polygon or what is the closest polygon to this point. 

To exit nano hit    

<kbd>Ctrl</kbd>+<kbd>x</kbd>

#### Creating the table

To create the table we just need to do the following SQL statement:

```psql -h localhost -U groot -f /data/crunchy_demo_data/boundaries/county_boundaries.dd.sql workshop```{{execute}}

We are telling the psql (the PostgreSQL command line client) that we want to connect to _localhost_ as user _groot_ and 
it should execute the ddl file in the _workshop_ database.  
When prompted for the password, remember that when we started the container we said the password would be _password_.

If all goes well you will see:
```
CREATE TABLE 
CREATE INDEX
CREATE INDEX
CREATE INDEX
```

For the rest of the examples of creating tables, this is what success will look like.

#### Loading the data

To load the data, the authors have already created a text file that can be loaded using the PostgreSQL 
[COPY](https://www.postgresql.org/docs/11/sql-copy.html) command. In our case, because we are unprivileged users AND 
the data does not reside in where the PostgreSQL server can see it, we have to log into our DB to use the \COPY command.  

If you want to look at the data you can use the Linux command _head_ to see just the first line

```head -n  1 /data/crunchy_demo_data/boundaries/county_boundaries_copy.txt```{{execute}}

We had to store the geometries as Well Known Binary (WKB) format to work with the copy command, hence the reason you are 
seeing all the random hexidecimal digits for most of the line. If you scroll up you can see this is for Cuming County, 
Alabama. 

The code book for the original data is located at :s

``` /data/crunchy_demo_data/boundaries/codebook_for_attributes.xml```

but we don't have time today to really dig in on the codebook.

If you look at the last line in the DDL file it has the syntax we need to use to load the data. All we need to do to make
the command work is change the path to the data file. All the following datasets also have the syntax for the COPY command 
in the last line of their DDL file. 

Because of word wrapping issues in teh learning platforms terminal we will just put the correct command here. If you 
do this at home you will have to change the path to the txt file to wherever you placed the data at home.

**First** 
Login to Postgresql 

```psql -U groot -h localhost workshop```{{execute}}

```\COPY county_geometry (statefp, countyfp, countyns, geoid, county_name, namelsad, funcstat, aland, awater, interior_pnt, the_geom) from '/data/crunchy_demo_data/boundaries/county_boundaries_copy.txt' WITH CSV QUOTE '"';```{{execute}}

When it is finished you should see:

```COPY 3233```

Congratulations!!! You now have loaded spatial data into your database.

The other exercises will go quicker now that we have the pattern down. We will only be pointing out non-typical database 
in the rest of the datasets

**NOTE** To exit from the SQL prompt type in `\q` and then hit enter
 
## Loading Storm Data

This data contains 3 tables:
1. Location of major storm events
1. Details of the storm events
1. Details about any fatalities with a storm event

The location of storm events tables is another spatial table with point data. We will use this later in the workshop 
to do spatial operations with the counties and point data. 

Since we already discussed spatial data we will load these tables without any discussion.

#### Make the tables

```psql -h localhost -U groot -f /data/crunchy_demo_data/storms/stormevents.ddl.sql workshop```{{execute}}

#### Load the data

```psql -U groot -h localhost workshop```{{execute}}

```\copy se_details from '/data/crunchy_demo_data/storms/StormEvents_details-ftp_v1.0_d2018_c20190130.csv' WITH CSV HEADER;```{{execute}}

```\copy se_fatalities from '/data/crunchy_demo_data/storms/StormEvents_fatalities-ftp_v1.0_d2018_c20190130.csv' with CSV HEADER;```{{execute}}

```\copy se_locations (episode_id, event_id, location_index, range, azimuth, location, latitude, longitude, the_geom) from '/data/crunchy_demo_data/storms/storm_locations_copy.txt' WITH CSV QUOTE '"';```{{execute}}


## Loading the county typology data

This data deals with some economic measures of the counties and their predominant industries. There is no special column 
types in this data so we can go through and load it quickly.

#### Make the table

```psql -h localhost -U groot -f /data/crunchy_demo_data/typology/CountyTypology.ddl.sql workshop```{{execute}}

#### Load the data:

```psql -U groot -h localhost workshop```{{execute}}

```\COPY county_typology from '/data/crunchy_demo_data/typology/2015CountyTypologyCodes.csv' with CSV HEADER``` {{execute}}



## Loading Wikipedia Data

The final dataset we are going to load is all the U.S. County pages from Wikipedia. This data was obtained by calling the 
wikimedia API and then storing the response parameters and JSON. We will use this data for free-text search, JSON data, 
and Key-Value columns. 

Let's look at how we enable those data/query types. 

#### Make the table

Let's use _nano_ again to look at the DDL statements:

```nano /data/crunchy_demo_data/wikipedia/wikipedia.ddl.sql```{{execute}}

The first three columns are standard PostgreSQL SQL. The fourth column, to hold the JSON content is declared as JSONB. 
We want to use JSONB over JSON for a couple of reasons:

1. With JSONB the B stands for binary so the data is compressed and provides more efficient storage
1. A JSON column is basically a text field with some simple validation. JSONB understands nested documents and 
with a GIN index you can query against all the fields and values. There is 
[good documentation](https://www.postgresql.org/docs/11/datatype-json.html#JSON-INDEXING) on indexing for JSONB 
columns.

The last statement also explains why we made a GIN index on the json_content field. 

Next we store the HTTP response fields in a hstore column, which is a column that allows for the storage of arbitrary 
key-value pairs. You can use a GIN or GIST index on hstore columns. Usually you would also have to enable the hstore 
extension in your database, but just like postgis, we have already added it to the default database.

Let's go ahead and create our table:

```psql -h localhost -U groot -f /data/crunchy_demo_data/wikipedia/wikipedia.ddl.sql workshop```{{execute}}     

#### Loading the data

```psql -U groot -h localhost workshop```{{execute}}

```\copy wikipedia (county, state, json_content, response_attr) from '/data/crunchy_demo_data/wikipedia/wikipedia_copy.txt' WITH CSV QUOTE '^';```{{execute}}

Now that we have populated our database time for some fun!