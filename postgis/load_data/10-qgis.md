While this course has focused on importing spatial data via the command line, 
we also want to highlight QGIS as an option. If you're a GIS professional, 
you're likely already using or are at least familiar with QGIS, but even if 
you don't specialize in GIS you might still find it helpful. (For example, we've 
found it more straightforward in QGIS to [view the EPSG code](https://docs.qgis.org/3.16/en/docs/user_manual/working_with_vector/vector_properties.html#information-properties) from shapefiles.) 

We're unable to set up a QGIS demo in this environment, but the official 
QGIS docs are helpful and there are many resources available from the internet.
 QGIS has a tool called [DB Manager](https://docs.qgis.org/3.16/en/docs/user_manual/plugins/core_plugins/plugins_db_manager.html#dbmanager)
 that allows you to integrate databases such as Postgres/PostGIS. 
 
Importing spatial data is as simple as adding your shapefile/GeoJSON/GIS file as a 
 layer in your QGIS project, and then using DB Manager to import the layer into 
 PostGIS. The DB Manager lets you export spatial data in various formats as well, and 
even allows you to run queries against your database from within QGIS. 

If you work with spatial data frequently enough, have access to a desktop 
client, and like using a graphical user interface, QGIS is worth learning how 
to use.
