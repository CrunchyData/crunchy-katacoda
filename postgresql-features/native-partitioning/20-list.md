List partitioning works by explicitly declaring which key value(s) appear in each partition. This can be useful for known text values (alphabetical, geographic) or even the results of an expression. The example below partitions by the values found in the `name` column with the first letter capitalized. The child tables define which values are valid for that child.
```
CREATE TABLE cities (
    city_id         bigserial not null,
    name         text not null,
    population   int
) PARTITION BY LIST (initcap(name));
```{{execute T1}}
CREATE TABLE cities_west
    PARTITION OF cities (
    CONSTRAINT city_id_nonzero CHECK (city_id != 0)
) FOR VALUES IN ('Los Angeles', 'San Francisco');
```{{execute T1}}
```
\d+ cities
```{{execute T1}}
```
\d+ cities_west
```{{execute T1}}


 
