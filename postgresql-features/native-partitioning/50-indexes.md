Index inheritance support was not introduced until PostgreSQL 11. In version 10, indexes had to be created manually when the child was created and could not be created at all on the parent. As of version 11, most indexes applied to the parent table will automatically be created when a child table is attached.
```
CREATE INDEX ON measurement (peaktemp);
```{{execute T1}}
```
\d+ measurement
```{{execute T1}}
```
\d+ measurement_20060203
```{{execute T1}}

The exception to this rule is that unique indexes that do not include the partition key cannot be created on the parent table. This is because global indexes are not yet supported in PostgreSQL, so unique constraint enforcement cannot be accomplished unless the partition constraints are also restricting the values that can exist in those child tables.
```
CREATE UNIQUE INDEX ON cities (city_id);
```{{execute T1}}
The above command will error because the `city_id` column is not part of the partition key. 
```
CREATE UNIQUE INDEX ON measurement (logtime);
```{{execute T1}}
The above, while not necessarily practical, works since the partition key is based on the logtime.

