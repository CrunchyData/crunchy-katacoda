Native logical replication works based off a replication identity using a publish/subscribe model. Subscribers pull data from the publications they subscribe to and can subsequently re-publish data to allow cascading replication. One or more tables can be added to a subscription and the same table can exist in multiple publications.

https://www.postgresql.org/docs/current/logical-replication-publication.html

Publications can choose which operations are replicated (INSERT, UPDATE, DELETE) and by default include all of them.

A published table must a have a replication identity in order to replicate updates and deletes. This is usually a primary key / unique index. It is possible to replicate tables without those, but then the entire row is treated as the identity and should be avoided if possible.

First let's create a some tables
```
psql
CREATE TABLE testing (id bigint PRIMARY KEY, logtime timestamptz DEFAULT now());
CREATE TABLE user_login (user_id bigint PRIMARY KEY, username text, last_login timestamptz DEFAULT now());
CREATE TABLE forum_posts (post_id bigint PRIMARY KEY, post text, post_time timestamptz DEFAULT now(), update_time timestamptz DEFAULT now());
```{{execute T1}}
Add some data
```
INSERT INTO testing (id) values (generate_series(1,10));
INSERT INTO user_login (user_id, username) values (generate_series(1,20), 'someuser'||generate_series(1,20));
INSERT INTO forum_posts (post_id, post) values (generate_series(1,100), 'somepost'||generate_series(1,100));
```{{execute T1}}
Now create some publications for our tables. We want all changes for the posts table to be replicated, but we do not want deletes replicated for the user_logins table. This can be useful to keep the subscriber table small for fast operations but not lose all history by keeping it at a remote location.
```
CREATE PUBLICATION forum_users_pub FOR TABLE user_login WITH (publish = 'insert,update');
CREATE PUBLICATION forum_posts_pub FOR TABLE forum_posts;
```{{execute T1}}
Privileges must also be granted to these tables to allow the logical replication role to read them
```
GRANT SELECT ON TABLE user_login TO replica_user;
GRANT SELECT ON TABLE forum_posts TO replica_user;
```{{execute T1}}

The tables are now ready for a logical replication subscriber. It's also possibly to create a publication that automatically includes all current tables and any tables that may be created in the future in the current database. We won't be doing the latter in this demo, but the 

