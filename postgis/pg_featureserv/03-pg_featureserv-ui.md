Now we want to give you a short tour of the pg_featureserv user interface (UI). The intent of the UI is to allow the user to quickly confirm the data is available through the service. It is not meant to be a finished UI for an end user application. 

With that in mind, click on the ```pg_featureserv``` tab and we'll take a look around.

## OpenAPI Schema and Conformance

### OpenAPI Schema

If you click on ```OpenAPI Schema``` it will take you to the built in Swagger documentation for the full API spec. (Click your browser's "back" button to return to the pg_featureserv home screen)

### Conformance

The Conformance link will take you to the list of links that describe the OGC API for Features spec.

## Collections and Functions

### Collections

Collections will list all of the tables that contain a valid geometry column (```geom```) that the pg_featureserv connecting account has permissions to. If a table is missing from this view that you were expecting to see, you can try the following troubleshooting steps:  

1. Verify user roles/permissions for the service account.  
2. Verify the table has a geometry column and the geometry is valid. 

### Functions

Functions is where you will find any user-defined functions made available to pg_featureserv. Note that we haven't added any functions yet, so this page should be empty. We'll go into user-defined functions in more detail on the next page. 

**NOTE:** pg_featureserv only looks at the ```postgisftw``` schema for functions. More on that on the next page.

## JSON and View

### JSON

If you click on a JSON link, it will take you to the full JSON response from the API for that particular path. As an example, clicking on JSON for Collections returns the response for `/collections`. This is what you will need/use for incorporating it into your user application. 

### view

Wiew (available under the Collections or Functions pages) will take you to a preview page that returns a limited set of features so you can verify that the features are being returned as expected. It comes with a basic basemap out of the box. 
