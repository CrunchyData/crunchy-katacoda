# Full Text Search in PostgreSQL

While most of you probably know of the SQL search you can do on text with LIKE or ILIKE, did you know that PostgreSQL has 
a full text analysis program built right in. The search capabilities are similar to those available in Lucene and 
its derivative such as ElasticSearch and SOLR. In this exercise we are going to show you how to setup and utilize 
[Full Text Search](https://www.postgresql.org/docs/11/textsearch.html) (FTS). 

#### Basic ideas in FTS

There is a [detailed discussion]    (https://www.postgresql.org/docs/11/textsearch-intro.html) in the documentation about the 
concepts in FTS. For now let's just focus on the steps (along with simplify the actual work).

1. The first step is to take the field(s) which have the content (a document) and analyze the text into words and phrases along with 
positions in the original text. 
    * One piece of this analysis is called a tokenizer, which identifies words. numbers, urls... in the original text
    * The other piece converts these tokens into "lexemes". A lexeme is a normalized words and you need a dictionary to 
    process for valid lexemes 
2. Then you store these store lexemes and their positions either in a column or an index
3. Now you use a search function that understands lexemes and positions in the original document to carry out the search. 
This search function **must** use the same dictionary that was used to create the lexemes.   

And with that **very** basic introduction let's get to it. We are going to do a FTS on the event narratives in the Storm 
Events details table.

#### Build the index

Building a FTS index is actually quite simple:

`CREATE INDEX se_details_fulltext_idx ON se_details USING GIN (to_tsvector('english', event_narrative));`{{execute}}

This function will take a little while to run as it tokenizes and lexemes all the content in the column.
The syntax is basically the same as creating any GIN index. The only difference is that we use the to_tsvector function, 
passing in the dictionary to use, 'english', and the field to analyze.

If you want to see the other default dictionaries PostgreSQL includes by default just query for it:

` \dF `{{execute}}

Quick note before we use that nice shiny index, there are actual two way to store the results of the text analyzer, 
either in an index or a in a separate column. 
While there is a full discussion of the tradeoffs in the [documentation](https://www.postgresql.org/docs/11/textsearch-tables.html#TEXTSEARCH-TABLES-INDEX) 
it boils down to:
1. With an index, when data is updated or inserted the index will automatically analyze it. On the downside, you, the 
application developer, need to know the dictionary that was used and still use the analysis function in your query.
2. With a column, your SQL syntax is cleaner and your performance with large indices will be better. The downside is you 
need to write a trigger to update the processed column anytime there is a change to the original document columns.

Today, for simplicity we chose to just use the index approach. If you do end up using a FTS we recommend you do some reading on the 
solution that works best for you.
   
#### Using the index

If we want to do a full text search we can now do something like this:

`select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('villag');`{{execute}}  

You will notice in the result set we are getting village and villages. To_tsquery is a basic search parser. 
This query also allows us to use the :* operator and get the search to do full stemming after the end of the word

`select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('english', 'villa:*');`{{execute}}
 
 We can also now look for phrases such as words that appear close together in the document. Let's look for some big hail:
 
 `select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('grapefruit <1> hail');`{{execute}}
 
 The *<1>* operator in this case tells the search to look for the words grapefruit and hail next to each other in the document. 
 As expected this return no results. But if we now change the distance between the words to allow for an intervening word
 we start to get what we expect:
 
 `select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('grapefruit <2> hail');`{{execute}}
 
 The order of the words using the <N> operator is order sensitive. Swapping grapefruit and hail we again get no results:
 
 `select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('hail <2> grapefruit');`{{execute}} 
  
You can also use | (OR) and ! (NOT) operators inside the to_tsquery(). Once you start writing more complicated search phrasings 
you should start to use parentheses to group search together.

The following search will find all documents with grapefruit OR the prefix golf with the word hail two words later.

`select begin_date_time, event_narrative from se_details where to_tsvector('english', event_narrative) @@ to_tsquery('(grapefruit | golf:* ) <2> hail');`{{execute}}

## Final notes on full text search

As you can see, we can do powerful and fast full text searching with FTS in PostgreSQL. Unfortunately, the documentation 
on this feature is actually quite sparse and difficult to interpret. If you want to learn this syntax you are going to have to dig in with debugging 
and trying different query techniques to get your desired results. 
One other [helpful document](https://www.postgresql.eu/events/pgconfeu2018/sessions/session/2116/slides/137/pgconf.eu-2018-fts.pdf) is a presentation by one of the lead developers.
Hopefully in the future the PostgreSQL community will update and improve this documentation.  

 
