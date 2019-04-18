# Storing and querying key-value pairs in a column

Sometimes the data you want to work with comes as key-value pairs and all the keys are not well defined before-hand. If you 
are a Java programmer this sounds like a Map (such as HashMap) and if you are a Python programmer this sounds like a Dictionary.
Postgresql allows you to handle this data with an extension named HSTORE. This extension allows for storing arbitrary number 
of key-value pairs in a column along with operators to search the key-value pairs. The number of key-value pairs can also 
vary between different rows.

## Two quick notes

While we are going to work with HSTORE today, you should realize that most of this functionality is superceded by the JSONB 
data type and there is not much ongoing work on HSTORE. A column with arbitrary key-value pairs can also be modeled as a 
flat JSON document but if, for some reason you don't want to use JSON, feel free to use HSTORE. 

Second, while it is very convenient to dump arbitrary key-value pairs (or JSON for that matter) into a column, we believe this
pattern of handling data should only be used in limited cases. Using these data types for most of your data has several 
potential drawbacks

1. JSON and Key-Value data storage can be order of magnitude times larger given that you are repeating the attributes or keys 
for every row. And while disks are cheap, retrieving more data from disk will always be a performance penalty. Indexing more 
data will always be more expensive as well.  
1. You lose the ability of the database to "enforce" that the proper data type, such as integer or float, is being stored 
in the database
1. You lose the ability to have the database keep track and manage relations between different data. This can quickly lead
to data orphans or data being out of sync
   

Make sure the benefits of using these datatypes outweighs the cost before using them.

Our recommended pattern is to process the JSON or Key-Value pairs and, as much as possible, store them in a well defined 
schema. Again you are free to do what you want, but this is our recommendation.

#### Querying Key-Value data
We already inserted key-value data into the wikipedia table. We took the response headers from the web request and stored them 
in the response_attr column. 

Let's start by taking a quick look at the data in the hstore column:

```select response_attr from wikipedia limit 2;```{{execute}}

Let's get all the unique values for the key "Date":

```select DISTINCT response_attr -> 'Date' from wikipedia order by response_attr -> 'Date';```{{execute}}

Since we only have second resolution, there are less entries for unique dates (762) than there are for wikipedia pages (3221)
crawled.

There is a [great table](https://www.postgresql.org/docs/11/hstore.html#id-1.11.7.25.5) showing all the operators and 
functions you can use. 

Now let's have some more fun, how about getting all the keys back as a set:

```select skeys(response_attr) from wikipedia limit 30;```{{execute}}

or just the unique keys:

```select distinct skeys(response_attr) from wikipedia;```{{execute}}

How about deleting an existing key-value pair from my home county of Rockland:

```select response_attr as "responses" from wikipedia where county = 'Rockland County';```{{execute}}

```update wikipedia set response_attr = delete(response_attr,'Server') where county = 'Rockland County';```{{execute}}

```select response_attr as "responses" from wikipedia where county = 'Rockland County';```{{execute}}

Finally, as a segue into our next topic, let's return a key-value row as a JSONB document

```select hstore_to_jsonb(response_attr) from wikipedia limit 1;```

As mentioned before, key-value columns are basically just a subset of JSONB functionality. 

## Final notes

I hope you started to get a good sense for the some of the possibilities you do with HSTORE data types in PostgreSQL. For 
more examples you can always look to [this document](http://www.postgresqltutorial.com/postgresql-hstore/). 
Again, just one more time, we recommend that use unstructured data types sparingly.  