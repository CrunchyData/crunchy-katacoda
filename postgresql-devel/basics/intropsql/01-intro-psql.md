## Introduction to `psql`

`psql` is described in the [docs](https://www.postgresql.org/docs/12/app-psql.html) as a "terminal-based front-end to PostgreSQL." This means that instead of having to use a GUI tool such as [pgAdmin](https://www.pgadmin.org/) to create, access, or manipulate a database, you can use text commands via a command line interface (CLI).

We'll get started by connecting to a database.

### Connect to the `workshop` database  

In your interactive terminal, you're currently logged in as root user, as indicated by the command line prompt:

<!-- add command line prompt image here -->

We want to connect to the PostgreSQL database as **groot**, so we'll enter the `psql` command, accompanied by some flags:

```
psql -h localhost -U groot -d workshop
```{{execute}}

Each command line flag or option begins with a `-` or `--`, and what follows after the space is the parameter you're passing in with the command.

1. The `-h` option specifies the host server (e.g. `localhost`), or socket directory.
2. `-U` specifies the user you're connecting as (`groot`).
3. `-d` specifies the database you're connecting to (`workshop`).

The CLI shows a response whenever a command is run. In this case, since you are logging in to a database as the user **groot**, the command line will then prompt you for the password (enter `password`). You won't see the password displayed as you type, but the terminal is recording your keystrokes.

<!-- add password prompt image here -->

Once you're logged in to the database server, the prompt in the terminal should change. The psql prompt indicates the database you're connected to, along with `=>`.

<!-- add psql prompt image here -->

The beauty of the command line is that there are often shortcuts or tips and tricks. For example, you could shorten the command used above even further to:

`psql -h localhost workshop groot`