 # Exclusion Constraints
 
 Our final scenario will cover Exclusion Constraints, which are actually used to compare between rows. If the expression with in the exclusion returns true then the insert or update will not proceed. Another way of phrasing this condition is that at least one of the conditions in the exclusion expression must return false for the data entry to proceed.
  
 These types of constraints are usually used to prevent a condition that you consider a data conflict. A good example would be a calendar application. You generally do not want to schedule two meetings at the same time for the same person. The exclusion constraint allows you to say no events can be schedule for the same sure user over the same time span.
 
 In our case we are going to prevent:  
 1. A person from having two different roles at the same time
 2. Two different people having the same role with overlapping times
 
 ## Date Range operators. 
 
You may have noticed in our *team\_role* table we used a [daterange](https://www.postgresql.org/docs/12/rangetypes.html#RANGETYPES-BUILTIN) type for role dates. Ranges bring with them a whole bunch of nifty [operators and functions](https://www.postgresql.org/docs/12/functions-range.html). 
 
 The operator we care about with daterange is `&&` which checks for "overlap (have points in common)". So in our case if any of the compared date ranges overlap then && will return true. Let's go ahead and add the first exclude constraint. Since there is no direct operator to do integer comparison in a GIST index (the type we are going to use), we first need to install the PostgreSQL extension. Extensions can only be installed by the superuser _postgres_.
 
 GIST indices natively work with a very limited [set of operators](https://www.postgresql.org/docs/12/gist-builtin-opclasses.html). Since _id_ is an integer, we need to install an extension that allows the GIST index to handle operators on simple data types, [btree_gist](https://www.postgresql.org/docs/12/btree-gist.html)  do not 

First, connect to the workshop database as postgres user (password _password_) 
```sql92
\c workshop postgres
```{{execute}}
Then install the extension:

```sql92
create extension btree_gist;
```{{execute}} 

Then go reconnect to workshop as _groot_ again (password _password_):

```sql92
\c workshop groot
```{{execute}}

Now we are all set to make our exclusion.  We have to use the longer declaration on this one:
 
 ```sql92
alter table team_role add constraint no_role_overlap EXCLUDE using gist ( people_id WITH =, role_dates with &&);
```{{execute}} 

"people_id WITH = " means the people_id can not be equal to a record that already exists. The "role_dates with &&" means the date range being entered cannot overlap with any of the existing date ranges. This means the same person cannot have two different roles over an overlapping time period.
 
 Now remember, for an insert or update we need the constraint evaluating to false. To have this happen all we need is one of the statements to be false.

Here is the data we originally inserted for Peter Quill:

```
insert into team_role (name, role_dates, people_id)  values ('mixtape master', '[2000-01-01, 2012-12-31]' , 2);
```

So if we try to give Peter another role with a time period that overlaps, like this:

```sql92
insert into team_role (name, role_dates, people_id)  values ('dance instructor', '[2004-06-15, 2010-03-16]' , 2);
```{{execute}}
The database stops us:

```
[23P01] ERROR: conflicting key value violates exclusion constraint "no_role_overlap"
Detail: Key (people_id, role_dates)=(2, [2004-06-15,2010-03-17)) conflicts with existing key (people_id, role_dates)=(2, [2000-01-01,2013-01-01)).

```

So let's change the date rang so that Peter becomes a "dance instructor" as a promotion from "mixtape master":

```sql92
insert into team_role (name, role_dates, people_id)  values ('dance instructor', '[2013-01-01, 2016-12-31]' , 2);
```{{execute}}

And now the transaction goes through because, while the _id_ is the same the date ranges no longer overlap and so that part of the constraint evaluates to false. 


### Another example

Another rule of our team is that only one person can have a role during any time period. The benefit of implementing this rule at the DB level is that if an application developer forgets this rule and doesn't add it to their data checks, Postgres will still prevent it.

Here is what the rule would look like: 

```sql92
alter table team_role add constraint no_sharing_roles EXCLUDE using gist (name WITH =, people_id WITH !=, role_dates with &&);
```{{execute}}
Now let's see what happens if Rocky tries to be a dance instructor during an overlapping time period with Peter:

```sql92
insert into team_role (name, role_dates, people_id)  values ('dance instructor', '[2014-01-01, 2015-10-31]' , 6);
```{{execute}}

You should get:

```
[23P01] ERROR: conflicting key value violates exclusion constraint "no_sharing_roles"
[2020-05-03 13:24:57] Detail: Key (name, people_id, role_dates)=(dance instructor, 3, [2014-01-01,2015-11-01)) conflicts with existing key (name, people_id, role_dates)=(dance instructor, 1, [2013-01-01,2017-01-01)).
```

But it we say Rocky is a "mad scientist" during this time, the data is entered without an error:

```sql92
insert into team_role (name, role_dates, people_id)  values ('mad scientist', '[2014-01-01, 2015-10-31]' , 6);
```{{execute}}

And with that, we have finished our coverage of exclusion constraints. You have also finished all the hands on exercises, time to wrap up!
 
 