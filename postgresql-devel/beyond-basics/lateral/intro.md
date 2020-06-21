# Getting Started With LATERAL Joins

This class helps you understand what LATERAL joins are and how to use them in PostgreSQL.

LATERAL Joins are extremely useful particularly when working with Set Returning Functions (SRFs) and when trying to get top-N type of results.

### Working with LATERAL Joins

So let's dig in and see how to use LATERAL joins.

We have loaded up a PostgreSQL database with Storm Event data from 2018 in the US. Here are the details on the database we are connecting to:
1. Username: groot
1. Password: password (same password for the postgres user as well)
1. A database named: workshop

> Warning: Depending on the version of the data loaded in the scenario the actual numbers may vary from the numbers shown here. The explanations and format will be the same, but there might be an difference in metrics such as actual rows returned or timings.  
