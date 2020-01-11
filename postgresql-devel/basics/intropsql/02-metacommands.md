## Meta-commands

The `psql` shell comes with meta-commands, which begin with an unquoted backslash.

### Get help

An example of one is `\?`, which will bring up help information.

```
\?
```{{execute}}

Press the spacebar to scroll through the list, or press `q` any time to return to the command line.

You should see the list of available meta-commands, including the one you just used. You'll see that the `\?` command can also include parameters that allow you to look up specific topics, e.g. `\? options` will bring up help information on psql options (flags).

### Describe a table

`\d` with the name of a table will display table metadata, e.g. columns, data types, attributes, constraints.

```
\dt se_details
```{{execute}}

`\d` used without any parameters will show a list of all available tables. If `+` is appended, you'll also see extended information such as the table's size on disk.

```
\d+
```{{execute}}

There are more in the `\d` set of meta-commands that you can use. Examples of more common ones are `\dn` (all schemas), `\dv` (all available views), `\du` (all users), `\df` (all functions).

## Options

As you saw in the earlier step, the `psql` command can be run with options.

One useful option is `--help`, which displays help information about `psql`, and then exits.

Let's log out of PostgreSQL first (by entering `\q`, or typing `CTRL`+`d`), and then run `psql` again.

```
\q
```{{execute}}

```
psql --help
```{{execute}}

Some options have equivalent meta-commands. For example, `psql --help` is the same as running `\h` within the `psql` shell.

<!-- man psql? -->

<!--Another is `-l`, which lists all databases and then exits. This is helpful for when you just want to look at the avaiable databases without connecting to the server.

```
psql -l
```{{execute}}-->
