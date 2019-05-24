# ST_Equals

ST_Equals(geometry A, geometry B) tests the spatial equality of two geometries.

![ST_Equals](assets/st_equals.png)

ST_Equals returns TRUE if two geometries of the same type have identical x,y coordinate values, i.e. if the second shape is equal (identical) to the first shape.

First, let’s retrieve a representation of a point from our nyc_subway_stations table. We’ll take just the entry for ‘Broad St’.
