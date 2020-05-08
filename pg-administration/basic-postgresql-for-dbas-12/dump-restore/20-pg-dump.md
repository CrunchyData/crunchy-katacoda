A plaintext dump of large databases typically wouldn't be very useful. To make up for this, the `pg_dump` command can be used to create a custom, binary dump format that can be compressed and filtered. It also allows parallalism for both dumping and restoring to greatly increase speed. Again, we will be sending this dump to the training user's home directory.

```
pg_dump -Fc -f /home/training/training.pgr -v training
```{{execute T1}}
The `-Fc` option tells pg_dump to create the output in its custom, binary format. The `-v` option provides more verbose output and is useful when dumping large databases to get some visual feedback on progress. The database that will be dumped is just given to pg_dump as an argument without any flags; in this case we're dumping out a database named `training`. If there are multiple databases in the instance, each one must be dumped out individually with separate calls to pg_dump. 

The `.pgr` extension for the dump file is arbitrary, but serves as a reminder that the file is made to be used by pg_restore.

See the documentation for full details on all of its options - https://www.postgresql.org/docs/current/app-pgdump.html
