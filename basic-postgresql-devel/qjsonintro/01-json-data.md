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

Our recommended pattern is to process the JSON or Key-Value pairs and, as much as possible, store them in a well defined 
schema. Again you are free to do what you want, but this is our recommendation.

With that, on to the JSONB

## Table with JSONB in it. 

Let's go ahead and log in to our PostgreSQL database:

```psql -U groot -h localhost workshop```{{execute}}

Remember that the password is the word 'password'.

Now if you do:

`\d wikipedia`{{execute}}

PostgreSQL will show you a full description of the wikipedia table. To see all the \ commands in PostgreSQL just do 
`\?` (though don't do it right now).

You will see one JSONB column named *json_content*. Again we are using JSONB because it allows for indexing and search

```
json_content  | jsonb   
```

You will also see that we created a GIN index on the JSONB column. GIN is the appropriate index type for JSON content.

```
    "wikipedia_json_content_indx" gin (json_content)
```


## Querying JSONB

Eventhough the JSON response from Wikipedia does not have a deep structure, we can still do 
some basic but interesting queries. 

The first thing to understand that there are two major JSONB operator types - ones that return JSON and other that return text. 
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
    "batchcomplete" : true,
    "warnings" :
    {
        "main":
        {
            "warnings":
            "Subscribe to the mediawiki-api-announce mailing list at <https://lists.wikimedia.org/mailman/listinfo/mediawiki-api-announce> for notice of API deprecations and breaking changes. Use [[Special:ApiFeatureUsage]] to see usage of deprecated features by your application."
        }
    ,
        "revisions":
        {
            "warnings":
            "Because \"rvslots\" was not specified, a legacy format has been used for the output. This format is deprecated, and in the future the new format will always be used."
        }
    }
    ...
```



We can use this syntax to get the text value of the revision warnings:

```select json_content -> 'warnings' -> 'revisions' ->> 'warnings'  from wikipedia limit 1; ```{{execute}}

Or we can use the JSON path operator

```select json_content #>> '{warnings,revisions,warnings}' from wikipedia;```{{execute}}


#### A more advanced query

Let's pretend we don't have the state and county already in the table but we want to query for Rockland County. If we look at 
the JSONB we see there is a normalization field that contains county names:

```javascript
{
...   
"query":
    {
        "normalized":
        [{"fromencoded": false, "from": "Autauga_County,_Alabama", "to": "Autauga County, Alabama"}],
        "pages":
        [{
        ...
        
```

So we can use that field in our where clause. Because it is in a JSON array nested deep in our structure we need to actually do
a subquery:

```
with normalized_to AS (
  select id, jsonb_array_elements(json_content #> '{query, normalized}') ->> 'to' as to_elements from wikipedia
) select wikipedia.id, to_elements from wikipedia, normalized_to where normalized_to.to_elements ilike 'rockland%' AND normalized_to.id = wikipedia.id;

```

## Final Notes on Working with JSON in PostgreSQL

Now we have seen how you can query and select different parts of your document. We didn't even cover containment or other
fun operations. One other fun thing to keep in mind you can also create 
indexes directly on a tree within the JSONB document, which is recommended if you are going within that document tree a lot.
