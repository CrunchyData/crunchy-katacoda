# More JSON Queries

## Building a query

Let's say we wanted to explore the different event categories. This exploration will require us to go deeper into our JSON structure. Here is the JSON snippet that shows the categories:

```javascript
{
	...
	"categories": [{
		"id": 8,
		"title": "Wildfires"
	}],
```

### Navigate down a tree
Let's start by just looking at some of the data in the field. 
> Our data sits in the an attribute, then in an array, then in another attribute:

```
select json_content #>> '{"categories",0,"title"}' from natural_events limit 10;   

```{{execute}}

We just used the JSON path operator to get the _categories_ attribute, then go to the _0th_ element in the array, then go to the _title_ attribute and return it's value as text.

### Use a grouping query

> Well how about we look to see all the distinct values the _title_ attribute can take. This is as simple as getting distinct values for any normal database value:

```
select distinct(json_content #>> '{"categories",0,"title"}') from natural_events;
```{{execute}}

### Using JSON in a WHERE clause 
                           
Volcanoes are cool (as long as you are not too close) so let's find all the events that are _Volcanoes_. There are JSON operators that test for containment and returns a True or False. The _@>_ operator let's you check to see if the _"attribute":"value"_ pair is found at the top level of JSON being evaluated. 

> Here is how we use it:

```
select json_content from natural_events where (json_content #> '{"categories",0}') @> '{"title":"Volcanoes"}' limit 5;
```{{execute}}       

## Section Wrap up
In this section we got to play around with how to use JSON operators in SELECT queries. For the final section we are going to update some JSON values in the documents. 


