## Meta-commands

The `psql` shell comes with meta-commands, which begin with an unquoted backslash.

### Get help

An example of one is `\?`, which will bring up help information about commands available in `psql`.

`\?`{{execute}}

> **Tip**
> Press the spacebar to scroll through the list, or press `q` any time to return  > to the `psql` prompt.

You should see the list of available meta-commands, including the one you just used. You'll see that the `\?` command can also include parameters that allow you to look up specific topics, e.g. `\? options` will bring up help information on psql options (flags).

The `\h` command will bring up a list of SQL commands. 

`\h`{{execute}}

And if you add the name of a command, you'll be shown more detailed information:

`\h ALTER INDEX`{{execute}}

### Describe a table

`\d` with the name of a table will display table metadata, e.g. columns, data types, and other attributes.

`\d se_details`{{execute}}

`\d` used without any parameters will show a list of all available tables in the current database. If `+` is appended, you'll also see extended information such as each table's size on disk.

`\d+`{{execute}}

Give it a try with a table name as well, and see the difference:

`\d+ se_details`{{execute}}

There are more in the `\d` set of meta-commands that you can use. Examples of more common ones are `\dn` (all schemas), `\dv` (all available views), `\du` (all users), `\df` (all functions).

## Options

As you saw in the earlier step, the `psql` command can be run with options.

One useful option is `--help`, which displays help information about `psql`, and then exits (i.e. you don't stay in the `psql` shell).

Let's log out of PostgreSQL first (by entering `\q`, or typing `CTRL`+`d`), and then run `psql` again with `--help` this time.

`\q`{{execute}}

`psql --help`{{execute}}

<!---
psql -l
-->
