# Unique and Not Null Constraints

In the last section, we learned that you had to write some sort of condition logic with a check constraint. With UNIQUE and NOT NULL constraints there is no condition to check. Let's start by looking at the Unique constraint.

## Unique Constraint. 

The UNIQUE constraint can be written as either a table or column constraint and ensures that there are no duplicate values in the column.  For example, Twitter usernames should be unique to the user. 

We can actually combine multiple constraints on the same column so let's go ahead and put a unique constraint on the twitter_username column:

```sql92
alter table people add CONSTRAINT unique_twitter UNIQUE (twitter_username);
```

and so now if we try to enter in a new person who claims to have the same Twitter username it won't work:

```sql92
insert into people (family_name, given_name, age, twitter_username) values ('Banner', 'Bruce', 41, 'trashpanda')
```

you should get this

```
23505] ERROR: duplicate key value violates unique constraint "unique_twitter"
Key (twitter_username)=(trashpanda) already exists.
```

If you look at the constraints again, you will see that PostgreSQL implemented this constraint by creating a B-tree index with UNIQUE constraint on the index. 

```sql92
\d people
```

So be aware, that a UNIQUE constraint will create an index on all the values of the field. If you don't want the size and write delays from a full index you can also create a [partial UNIQUE index](https://www.postgresql.org/docs/12/indexes-partial.html) (covering that is beyond the scope of this class).

Remember you can also declare constraints against multiple columns. So you could also ensure there are no duplicates of the combination family name, first name, and age by doing:

```sql92
alter table people add CONSTRAINT unique_name_age UNIQUE (family_name, given_name, age);
```

## NOT NULL constraint

The same general pattern works for a NOT NULL constraint. This constraint type prevents a NULL (no data) value from being inserted into a column. Again, the constraint can be used in conjunction with any of the other constraint types. 

We need to have a family name in our application so let's insure that there is always data for this field. The syntax for adding a NOT NULL constraint after table creation is a bit different. Instead of adding a constraint we just set a condition on the column:

```sql92
alter table people alter column family_name set NOT NULL;
``` 

Now let's try to enter a person without a last name:

```sql92
insert into people ( given_name, age, twitter_username) values ('nebula', 28, 'daddyissues');
```

Which ends up giving us error:

```
[23502] ERROR: null value in column "family_name" violates not-null constraint
Detail: Failing row contains (9, null, nebula, 28, daddyissues).
```

And with that we have covered these two simple, yet powerful constraints for insuring clean data. In the next section we are going to cover some constraints that core to the relational nature of databases, _primary keys_ and _foreign keys_.