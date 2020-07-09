# Introduction to Vector Tiles and pg_tileserv

This scenario gives you a hands-on introduction to vector tiles and [pg_tileserv](https://access.crunchydata.com/documentation/pg_tileserv/latest/).

Vector tiles are a bandwidth-efficient method of transferring spatial data over the web for display in web maps. For a brief history of web maps and vector tiles, watch [Paul Ramsey's presentation at PostGIS Day 2019](https://youtu.be/t8eVmNwqh7M "PostGIS Day 2019 Vector Tiles"). 

With the release of PostGIS 2.4, [PostGIS](https://postgis.net/) introduced the ability to generate vector tiles directly from the database. This provided developers with the ability to have constantly up-to-date vector tiles in their web maps. However, it also required developers to write their own API to leverage this functionality. Pg_tileserv was created to make it easy to service enable your spatial data and integrate it into your web application. 

To use pg_tileserv, you need to have a PostGIS database with spatial data loaded in it. The database has already been started and the spatial data has already been loaded. This scenario will use data from New York City (NYC). 

This exercise demonstrates how to connect pg_tileserv to your database and shows the resulting vector tiles. We also provide an example of how pg_tileserv works with user-defined functions. If you would like to learn more about creating funcitons, please review our [Basics on Writing Functions](https://learn.crunchydata.com/postgresql-devel/courses/beyond-basics/basicfunctions) scenario. Data from this scenario is used in our other exercises as well, but the environments don't persist between scenarios.

Here are the details on the database we are connecting to:

1. Username: groot
2. Password: password (same password for the postgres user as well)
3. A database named: nyc

And with that, let's dig in.

