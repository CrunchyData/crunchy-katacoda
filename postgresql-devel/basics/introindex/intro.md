When working with databases, one of the things you'll care most about is how 
quickly you'll be able to find and retrieve data that you want. Not only might 
it make for a poor user experience if a user has to wait too long to complete a
 task (even a few seconds can be considered unacceptably 
 long!), sometimes even a mere fraction of a second makes all the difference, especially for mission-critical applications.

An index helps with finding data rows quickly and efficiently. In this 
scenario, we'll try our hand at creating indices for a sample table with 
data already loaded in. We'll also use the EXPLAIN (ANALYZE) command to take 
a look at how indexes affect querying. If you'd like to review [EXPLAIN](https://learn.crunchydata.com/postgresql-devel/courses/basics/explain) first, feel free to go through that scenario before coming back to 
this one.

The data we're using is storm event data in the United States from 2018 
(downloaded from [ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/](ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/)). The scenario will load the PostgreSQL instance and connect 
you to the database using the following credentials:

1. Username: groot
2. Password: password
3. Database: workshop
