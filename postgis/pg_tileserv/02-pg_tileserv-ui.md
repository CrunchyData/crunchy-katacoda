Now we want to give you a short tour of the pg_tileserv user interface (UI). The intent of the UI is to allow the user to quickly confirm the data is available through the service. It is not meant to be a finished UI for an end user application. 

With that in mind, click on the ```pg_tileserv``` tab and we'll take a look around.

## Service Metadata

The service metadata provides basic information in JSON format to make it discoverable by other services. 

## Table Layers

Table layers will list all of the tables that it has access to that contain a valid geometry column (```geom```). If a table is missing from this view that you were expecting to see, you can try the following troubleshooting steps:  

1. Verify user roles/permissions for the service account.  
2. Verify the table has a geometry column and the geometry is valid. 

## Function Layers

Functions is where you will find any user-defined functions made available to pg_tileserv. Note that we haven't added any functions yet, so this section should be empty. We'll go into user-defined functions in more detail on the next page. 
