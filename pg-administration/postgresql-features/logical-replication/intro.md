# Logical Replication
The default replication process in PostgreSQL is great for high-availability and read-only query distribution. But there are cases where the entire database does not require replication or being able to write to the replicas is necessary. Third-party tools have been available to PostgreSQL to allow this for quite a while (Bucardo, Slony, mimeo, etc).  But the complicated setups involved or write-amplification they can cause mean they were less than ideal solutions.

Starting in PG 9.4, the WAL stream introduced a new mode to provide logical change information via its native replication protocol. And as of version 10, a method to perform logical replication of tables has been built into PostgreSQL.

The current restrictions on logical replication are mentioned in the documentation and vary between major versions - https://www.postgresql.org/docs/current/logical-replication-restrictions.html

Let's get started!
