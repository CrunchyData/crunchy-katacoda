# Working with JSON(B) data PostgreSQL

PostgreSQL has quite advance JSON capabilites, especially with the addition of JSONB. The B in JSONB stands for binary, meaning the document is actually stored in binary format. This gives us a couple of advantages:

1. The document takes up less space as JSONB
2. We can index JSONB giving us all the benefits of database indices.

If you just want to store your JSON as Text Large Object that you only reproduce wholesale and never query, then go ahead 
and make the column a JSON type, otherwise use JSONB 

## A quick note

While it is very convenient to dump arbitrary key-value pairs (or JSON for that matter) into a column, we believe this
pattern of handling data should only be used in limited cases. Using these data types for most of your data has several 
potential drawbacks

1. JSON data storage can be an order of magnitude times larger given that you are repeating the attributes  
for every row. And while disks are cheap, retrieving more data from disk will always be a performance penalty. Indexing more 
data will always be more expensive as well.  
1. You lose the ability of the database to "enforce" that the proper data type, such as integer or float, is being stored 
in the database
1. You lose the ability to have the database keep track and manage relations between different data. This can quickly lead
to data orphans or data being out of sync

Make sure the benefits of using these datatypes outweighs the cost before using them.

Our recommended pattern is to process the JSON and, as much as possible, store them in a well defined 
schema. Again you are free to do what you want, but this is our recommendation.

With that, on to the JSONB

## Table with JSONB in it. 

Let's go ahead and log in to our PostgreSQL database:

```psql -U groot -h localhost workshop```{{execute}}

Remember that the password is the word 'password'.

Now if you do:

`\d natural_events`{{execute}}

PostgreSQL will show you a full description of the natural events  table. To see all the \ commands in PostgreSQL just do 
`\?` (though don't do it right now).

You will see one JSONB column named *json_content*. Again we are using JSONB because it allows for indexing and search

```
json_content  | jsonb   
```

You will also see that we created a GIN index on the JSONB column. [GIN](https://www.postgresql.org/docs/11/gin-intro.html) 
is the appropriate index type for JSON content.

```
"natural_events_json_content_indx" gin (json_content)
```


## Querying JSONB

Eventhough the JSON data is not deeply structured, we can still do interesting queries. 

But first you NEED to understand there are  two major JSONB operator types - ones that return JSON and other that return text. 
For example, this operator `->` gets a JSON object field by a key and returns JSON:

```javascript
'{"a": "value"}'::json->'a'  = "value"
```

while the `->>` operator returns values as text. 

```javascript
'{"a": "value"}'::json->>'a'  = value

```

This matters because when an object is returned as JSON you can pass it to another operator, thereby chaining operations. 

For example our JSON has this structure (starting at the top)

```javascript
{
	"id": "EONET_4313",
	"link": "https://eonet.sci.gsfc.nasa.gov/api/v2.1/events/EONET_4313",
	"title": "Wildfire - Sardinia, Italy ",
	"sources ": [{
		"id ": "PDC ",
		"url ": "http://emops.pdc.org/emops/?hazard_id=95355"
	}],
	"categories": [{
		"id": 8,
		"title": "Wildfires"
	}],
	"geometries ": [{
		"date ": "2019 - 07 - 31 T18: 09: 00 Z ",
		"type ": "Point ",
		"coordinates ": [8.9824, 40.09573]
	}],
	"description": ""
}
   
```



> We can use this syntax to get the text value of the title of the data set:

```select json_content ->> 'title' from natural_events limit 1; ```{{execute}}

> Or we can use the JSON path operator:

```select json_content #>> '{title}' from natural_events limit 1;```{{execute}}

> But if we change the operator to return JSON you will see the answer is in quotes: to indicate it is JSON:

```select json_content #>> '{title}' from natural_events limit 1;```{{execute}}


## Wrap up
Now that we have written a basic query and discussed JSONB let's move on to more exciting queries.