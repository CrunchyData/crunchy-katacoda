# Working with JSON(B) data PostgreSQL

PostgreSQL has quite advance JSON capabilites, especially with the addition of JSONB. The B in JSONB stands for binary, meaning
the document is actually stored in binary format. This gives us a couple of advantages:

1. The document takes up less space as JSONB
2. We can index JSONB giving us all the benefits of database indices. 

Just a quick reminder as a I said in the previous scenario - please consider using JSON data storage sparingly if at 
all since it gives you the benefit of convenience but at a high price.

With that, on to the JSONB

## Querying JSONB

We stored the reponse from Wikipedia as JSONB but it is not a very rich document structure. Even without that we can still do 
some basic but interesting queries. 

The first thing to understand that there are two major operator types - ones that return JSON and other that return text. 
For example, this operator `->` gets a JSON object field by a key and returns JSON:

```javascript
'{"a": "value"}'::json->'a'  = "value"
```

while the `->>` operator returns values as text. 

```javascript
'{"a": "value"}'::json->>'a'  = value

```

This matters because when an object is returned as JSON you can pass to another operator, thereby chaining operations. 

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

We can use this syntax to get the value of the revision warnings:

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

So we can use that field in our where clause. Because it is in an JSON array nested deep in our structure we need to actually do
a subquery:

```
with normalized_to AS (
  select id, jsonb_array_elements(json_content #> '{query, normalized}') ->> 'to' as to_elements from wikipedia
) select wikipedia.id, to_elements from wikipedia, normalized_to where normalized_to.to_elements ilike 'rockland%' AND normalized_to.id = wikipedia.id;

```

## Final Notes on Working with JSON in PostgreSQL

Now we have seen how you can query and select different parts of your document. We didn't even cover containment or other
fun operations. One other fun thing to keep in mind you can also create 
indexes directly on a field in a JSONB field, which is recommended if you are going to query that field quite a bit.
