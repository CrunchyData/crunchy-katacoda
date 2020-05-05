While we've dipped our toes into some of the "advanced" data types supported 
in Postgres, we want to mention a few that we haven't included in this course:

### JSON

Postgres supports JSON, and there are two types for storing JSON data: `json`, 
and `jsonb`. To get your feet wet with this data type, and to learn a little 
more about why `jsonb` would be preferable, check out our [Intro to JSON in PostgreSQL course](../../courses/beyond-basics/qjsonintro/)
 right here in the Learning Portal.

### Text search

Postgres provides data types to support full text search: `tsvector` and 
`tsquery`. Learn more in our [Intro to Full Text Search in PostgreSQL]() 
course.

### User-defined types

You also have the ability to create your own custom data types in Postgres. To 
do so, you could use the [CREATE TYPE](https://www.postgresql.org/docs/current/sql-createtype.html) 
statement (which you'll recall we used to create our enum type), or [CREATE DOMAIN](https://www.postgresql.org/docs/current/sql-createdomain.html). 
You could even go as far as creating your own [custom base types](https://www.postgresql.org/docs/current/xtypes.html) if necessary.