This exercise shows you the steps to add pg_tileserv to your PostGIS implementation. 

First, take a look at the tab in the terminal to the right called "pg_tileserv". You'll see that it's still waiting for an available conneciton on port 7800, the port that pg_tileserv serves data on. That's because we haven't added pg_tileserv to our PostGIS implementation yet. Let's do that now.

## Add pg_tileserv

To add pg_tileserv to your PostGIS database, you need to either download the [source code](https://github.com/CrunchyData/pg_tileserv), the binaries, or one of our supported containers. We'll use the container version of pg_tileserv for this scenario. 

The code block below allows you to click on it to have the code execute in the terminal. Be sure to click in the ```Terminal``` tab before clicking the code block to make sure the code executes in the correct tab. You also have the option of copying and pasting the code, or typing it yourself in the ```Terminal``` tab.

```docker run -p 7800:7800 --env=DATABASE_URL=postgres://groot:password@172.18.0.2/nyc pramsey/pg_tileserv:CI```{{execute}}

You'll see that the connection info we provided in the intro (database name: `nyc`, username: `groot`, and password: `password`) is used in the statement above. 

You should see lines of output like this in the terminal:

```sh
time="2020-07-02T14:06:45Z" level=info msg="pg_tileserv CI"
time="2020-07-02T14:06:45Z" level=info msg="Run with --help parameter for commandline options"
time="2020-07-02T14:06:45Z" level=info msg="Using database connection info from environment variable DATABASE_URL"
time="2020-07-02T14:06:45Z" level=info msg="Serving HTTP  at 0.0.0.0:7800"
time="2020-07-02T14:06:45Z" level=info msg="Serving HTTPS at 0.0.0.0:7801"
time="2020-07-02T14:06:45Z" level=info msg="Connected as 'groot' to 'nyc' @ '172.18.0.2'"
time="2020-07-02T14:06:47Z" level=info msg="HEAD /" method=HEAD url=/
time="2020-07-02T14:06:50Z" level=info msg="GET /" method=GET url=/
```

Now, if you look at the pg_tileserv tab again, you'll see the default UI as well as all of the NYC data being delivered as vector tiles (under ```Table Layers```).

Next, we'll go over the default UI and then show you how to add a user-defined function and have it available via pg_tileserv.
