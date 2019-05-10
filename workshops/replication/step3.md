## Load data 
```
psql davec
\i /data/crunchy_demo_data/typology/CountyTypology.ddl.sql
\copy county_typology from '/data/crunchy_demo_data/typology/2015CountyTypologyCodes.csv' with csv header;
table county_typology;
```{{execute}}