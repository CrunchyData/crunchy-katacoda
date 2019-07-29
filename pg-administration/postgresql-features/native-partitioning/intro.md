# Partitioning in PostgreSQL
As of PostgreSQL 10, partitioning is now a native feature. Version 10 laid the groundwork for the syntax but was still lacking in some major features. 11 improved upon the feature support greatly, and 12 will continue on with that improvement.
 
Before version 10, partitioning was possible in PostgreSQL, but it was a result of a combination of several other features: Inheritance, Constraints & Triggers. The method was laid out in previous versions' documentation and is still available now, for example in version 9.6 - https://www.postgresql.org/docs/9.6/ddl-partitioning.html

Depending on the features needed with your partitioning requirements, the old method may still need to be used. If you are going into a brand new partitioning setup, it is highly recommended to upgrade to version 11 to have much better feature support built in.

Let's get started!
