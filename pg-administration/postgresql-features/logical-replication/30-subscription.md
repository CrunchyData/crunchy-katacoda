A subscription is the downstream side of logical replication and defines the connection to another database and the set of publications it wants to receive. 

https://www.postgresql.org/docs/current/logical-replication-subscription.html

Each subscription receives changes via one replication slot, which is a special replication object that exists on the publisher side to allow it to keep track of where the subscriber may be in the WAL stream. It also prevents the publisher from prematurely cleaning up its WAL files before all subscribers have acknowledged they've received the data. This means it is critical to monitor replication status and disk space usage to prevent the publisher from running out of disk space. The slot is automatically created whenever a subscriber is created and dropped when the subscription is dropped. Please see the documentation link above for several caveats regarding slot management.

Schema changes are not replicated via logical replication and the objects must first exist on the subscriber end to receive the relevant data. Initial data does not have to exist when first subscribing and an initial snapshot of all relevant data will be pulled over first.

This scenario has a database instance already set up to be the subscriber running on port 5444. To make things easier to follow, commands for the subscriber will be sent to the second terminal labeled `subscriber_terminal`. Please click that terminal tab now to ensure it is initialized.

As stated before, schema changes are not replicated, so the tables receiving subscription data must first exist and their object names must match exactly. Columns are also matched by name & type, however order does not have to match and the subscriber can have additional columns not provided by the publisher. If schema does change on the publisher that the subscriber cannot handle, errors will be reported in the logs and the slot will cause the publisher to hold all WAL until the errors are fixed. It's generally best to first add the changes to the subscriber side then apply them to the publisher. Again, please review the restrictions on logical replication - https://www.postgresql.org/docs/current/logical-replication-restrictions.html

Our setup is rather simple, so just recreating the tables manually is easy. For larger setups, it's more useful to use the `--schema-only` option to `pg_dump` to dump out the structure of the desired objects and restore them to the subscriber.
```
psql -p 5444

CREATE TABLE user_login  (user_id bigint PRIMARY KEY, username text, last_login timestamptz DEFAULT now());

CREATE TABLE forum_posts  (post_id bigint PRIMARY KEY, post text, post_time timestamptz DEFAULT now(), update_time timestamptz DEFAULT now());
```{{execute T2}}
```
CREATE SUBSCRIPTION forum_post_sub CONNECTION 'dbname=root host=127.0.0.1 user=replica_user password=12345' PUBLICATION forum_posts_pub;

CREATE SUBSCRIPTION user_login_sub CONNECTION 'dbname=root host=127.0.0.1 user=replica_user password=12345' PUBLICATION forum_users_pub;
```{{execute T2}}
This creates replication slots for this subscription back on the publisher database...
```
-- run on publisher
SELECT * FROM pg_replication_slots;
```{{execute T1}}
...and pulls all the currently existing data for the tables that are part of that publication. 
```
-- run on subscriber
SELECT count(*) from user_login;
SELECT count(*) from forum_posts;
```{{execute T2}}

From this point onward, any data changes to those tables will be replicated.
```
-- new user login on publisher
INSERT INTO user_login (user_id,username) values (21, 'someuser21');

-- new post on publisher
INSERT INTO forum_posts (post_id,post) values (101, 'somepost101'); 
```{{execute T1}}
Check replica again
```
SELECT count(*) from user_login;
SELECT count(*) from forum_posts;
```{{execute T2}}
And let's see that our deletes for users are not being replicated
```
-- run on publisher
DELETE FROM user_login WHERE user_id < 10;
DELETE FROM forum_posts WHERE post_id < 20; 
```{{execute T1}}
Check replica again
```
SELECT count(*) from user_login;
SELECT count(*) from forum_posts;
```{{execute T2}}

Note that, unlike normal replication, writes are still possible on the subscriber end to tables that are part of a subscription. This means that conflicts can occur if data is written to the subscriber that would cause logical replication to fail. The cause of the conflict will be noted in the subscriber's logs. This must be fixed manually by either adjusting the data or using a built-in function for replication to advance past it. See the conflicts sections of the documentation for how to do this - https://www.postgresql.org/docs/current/logical-replication-conflicts.html.

Also note that SEQUENCE values are not handled via logical replication at this time either. The sequence values that get populated in the publisher's table will be repicated without issue. But if the same sequence exists on the subscriber, it will not be incremented since the value is being set directly on the table and not relying on the sequence to supply the value. This normally isn't an issue unless the subscriber is meant to be any sort of failover node.
