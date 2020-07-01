Now you've seen how easy it is to add pg_featureserv to your PostGIS implementation. Let's take a minute to explain what's going on behind the scenes, and the layout of the default UI. 

## Exposing your data as spatial features

When pg_featureserv connects to the PostGIS database, it will automatically expose any tables with a valid geometry column (```geom```) it has permissions to. With this in mind, it is important that you create a separate user role, with the necessary permissions assigned to it, just for pg_featureserv. Pg_featureserv does not add any authentication to the API, so it is possible to expose your database to malicious actors if you don't assign proper user roles. 

## Why expose all spatial data?

Pg_featureserv was created to address the issue of requiring multiple points of configuration typically found in a tradional GIS stack. With pg_featureserv, your database is your configuration. There is power and efficiency in this approach, but it does require you to think a bit more about your database configuration than perhaps you may have in the past. The nice part about this is you only have to worry about the database, and not having to make changes through out your tech stack.
