## Running queries in `psql`

Once you're in the `psql` shell (i.e. logged in), you can run SQL commands.

Let's log back in and try running a simple query:

```
psql -h localhost -U groot -d workshop
```{{execute}}

```
SELECT cz_name FROM se_details LIMIT 5;
```{{execute}}

Note that SQL statements need to end in a semicolon. The `psql` command or other command-line statements, however, do not.

### Multiline queries

You can press `ENTER` in the `psql` shell if you want the SQL statement to continue on a new line -- `psql` won't process the statement until you add the semicolon at the end of a line.

<!-- add multiline image here -->

You'll see that the command line prompt starts with a `=>`, but changes to a `->` if the statement continues on to the next line (i.e. if you press enter without ending with a `;`). The prompt doesn't change back to `=>` until the statement ends and runs.
