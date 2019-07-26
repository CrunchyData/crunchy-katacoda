Hash partitioning was introduced in PostgreSQL 11 and can be used to partition growing partition sets evenly between a given number of child tables. Each child partition will hold the rows for which the hash value of the partition key divided by the specified modulus will produce the specified remainder.
```
CREATE TABLE users (
    username    text         not null,
    password    text,
    created_on  timestamptz  not null default now(),
    id_admin    bool         not null default false
) PARTITION BY HASH (username); 
```{{execute T1}}
```
CREATE TABLE users_p0 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 0);
CREATE TABLE users_p1 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 1);
CREATE TABLE users_p2 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 2);
CREATE TABLE users_p3 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 3);
CREATE TABLE users_p4 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 4);
CREATE TABLE users_p5 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 5);
CREATE TABLE users_p6 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 6);
CREATE TABLE users_p7 PARTITION OF users ( primary key (username) ) FOR VALUES WITH (MODULUS 8, REMAINDER 7);
```{{execute T1}}
```
\d+ users
```{{execute T1}}
```
\d+ users_p1
```{{execute T1}}
Let's add some data into this partition set to see how it gets split up
```
\copy users (username) from stdin;
proffers
babbles
cents
choose
chalked
redoubts
pitting
coddling
relieves
wooing
codgers
sinewy
separate
ferry
crusty
cursing
hawkers
deducted
gaseous
voyagers
\.
```{{execute T1}}
And now let's check the data distribution
```
SELECT tableoid::regclass as partition_name, count(*) FROM users GROUP BY 1 ORDER BY 1;
```{{execute T1}}
