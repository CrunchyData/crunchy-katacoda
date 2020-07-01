# Intro to pg_featureserv

This scenario gives you an introduction to pg_featureserv.

To use pg_featureserv, you need to have a PostGIS database with spatial data loaded in it. The database has already been started in this learning environment and the spatial data has already been loaded. This scenario will use data from census data from New York City (NYC). 

This exercise shows how to connect pg_featureserv to your database and shows the resulting features. We also demonstrate an example of using user-defined functions through pg_featureserv. If you would like to learn more about creating functions in PostgreSQL, please review our [Basics on Writing Functions](https://learn.crunchydata.com/postgresql-devel/courses/beyond-basics/basicfunctions) scenario. Data from this scenario is used in our other exercises as well, but the environements don't persist between scenarios.

Here are the details on the database we are connecting to:

1. Username: groot
2. Password: password (same password for the postgres user as well)
3. A database named: nyc

## pg_featureserv

Pg_featureserv is a lightweight RESTful geospatial feature server for [PostGIS](https://postgis.net/), written in [Go](https://golang.org/).
It supports the [OGC API - Features](http://docs.opengeospatial.org/is/17-069r3/17-069r3.html) REST API standard.

Pg_featureserv uses PostGIS to provide geospatial functionality, namely:
  * Transforming geometry data into the output coordinate system
  * Marshalling feature data into GeoJSON

Pg_featureserv requires **PostGIS 2.4 or greater** to operate.

That's great, but you might be askingL "What does it do? How does it work?" Pg_featureserv works by taking an HTTP request and converting it to the neccessary SQL to have PostGIS return the spatial data as a feature. Pg_featureserv connects to the target PostGIS database via a Database URL [connection string](https://www.postgresql.org/docs/10/libpq-connect.html#LIBPQ-CONNSTRING). It runs in a completely stateless manner, and any configuration of the data layers is driven by the underlying database. This means that data scientists, analysts and stewards can focus on maintaining their data and data structures. 

Now, let's get to showing you how easily it can be added to your PostGIS implementation and expose features. 
