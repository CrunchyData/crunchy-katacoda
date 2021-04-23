# Final Notes 

In this class you go received an introduction to PostgreSQL constraints - a very effective method to insure the integrity of your data. We covered:

1. Check Constraints - make sure the data being entered meets criteria
1. Not Null Constraints - make sure a NULL value is not entered in a column 
1. Unique Constraints - make sure there are no duplicate values in a column
1. Primary Keys - insure each row in the database has a unique identifier
1. Foreign keys - make sure parent-child table retain data integrity
1. Exclusion Constraints - prevent data from "overlapping", either over a range or against a range of column values.

The easiest way to create these constraints is at table definition time, but we also added them to the tables, even after data was added to the table. 
 
The container used in this class is available [in Dockerhub](https://hub.docker.com/r/crunchydata/crunchy-postgres-appdev.) As long as you have Docker on your machine you can use the same version of PostgreSQL as the workshop. Now you have a quick and easy way to spin up PostgreSQL without installing binaries, compiling software, or any other administrative tasks.
 
 We hope you keep using Constraints for a better database experience.

 _Enjoy learning about PostgreSQL? [Sign up for our newsletter](https://www.crunchydata.com/newsletter/) and get the latest tips from us each month._