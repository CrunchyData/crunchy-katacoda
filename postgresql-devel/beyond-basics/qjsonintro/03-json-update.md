# Updating JSON with PostgreSQL 

## Updating our Event Category Titles

> Let's modify our query where we found all the distinct Title values and now include the counts in each category:   

```
select json_content #>> '{"categories",0,"title"}' as title, count(id) from natural_events GROUP BY json_content #>> '{"categories",0,"title"}';
```{{execute}}
              
We can see there is a category that has _"Severe Storms"_. That seems a bit excessive, how about we call them just _"Bad Weather"_. 

We do this using a very similar query as before when we selected all the events that were volcanic. The new part will be doing the insert into an existing document. 

> The update statement looks like this:
```
UPDATE natural_events SET json_content = jsonb_set(json_content, '{"categories",0,"title"}', '"Bad Weather"') where (json_content #> '{"categories",0}') @> '{"title":"Severe Storms"}';  
```{{execute}}
                       
We are basically setting the JSON value equal to the JSON value with the title updated. 

> Check out your new results:

```
select json_content #>> '{"categories",0,"title"}' as title, count(id) from natural_events GROUP BY json_content #>> '{"categories",0,"title"}';
```{{execute}}

## Final Notes on Working with JSON in PostgreSQL

Now we have seen how you can query, select, and update different parts of your JSON documents in PostgreSQL. We didn't even cover  other  [fun operations](https://www.postgresql.org/docs/11/datatype-json.html). There is a [full page](https://www.postgresql.org/docs/11/functions-json.html) of JSON functions and operators, go ahead and start playing with them right now in this class if you want. One other fun thing to keep in mind you can also create indexes directly on a tree within the JSONB document, which is recommended if you are going within that document tree a lot.

