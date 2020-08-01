# GiST Index

GIST stands for Generalized Search-Tree. 

## Purpose
Remember, the B-tree operates based on the data that is naturally sortable so that <, >, and = can be used to generate the tree structure. This format won't work for things like geospatial objects or full-text search. The GiST, like its name implies, has the ability to create a tree structure using arbitrary "splitting" based on a custom operator. For example, in PostGIS, the GiST spatial indexing happens with an R-Tree under the hoods. 

Any datatype you can describe with a split method and a compare method you can leverage the GIST infrastructure to make an index. 

Another benefit to using a GiST index is that the implementation can use keys that are derived from the data and not the data itself. In a B-Tree index for an integer column, the nodes in the tree are going to be integers. In the GiST for PostGIS spatial data, the index is built using the bounding boxes for the spatial features no matter the complexity of the shape. So the bounding box is used when going through the index but then it points to the data that it represents. 

This difference between keys in the index and the actual data often means that for GiST indexes there is an initial pass through the index to get candidate matches and then a second stage to check for exact matches. This double pass on the data can cause a degradation in search time. On the other hand, it will probably be faster than a search with no index at all, especially on things like complicated geometries or range overlap. 
   
There is an extension, [btree_gist](https://www.postgresql.org/docs/current/btree-gist.html), that uses the B-tree indexing inside the GiST, which is really useful if you want to combine spatial data and something like a text or integer field into a multi-column GiST index.

## Operators

PostGIS


A GiST index can accelerate queries involving these range operators: =, &&, <@, @>, <<, >>, -|-, &<, and &>
from https://medium.com/dataseries/range-types-in-postgresql-and-gist-indexes-788db23346c5
https://www.postgresql.org/docs/current/functions-range.html

Per the official documentation, Full Text also supports GiST but GIN is [the recommended](https://www.postgresql.org/docs/current/textsearch-indexes.html) index type.

## Size and Speed

### Before an Index


### After an Index

https://www.postgresql.org/docs/12/gist.html

https://www.postgresql.org/docs/12/btree-gist.html

https://habr.com/ru/company/postgrespro/blog/444742/