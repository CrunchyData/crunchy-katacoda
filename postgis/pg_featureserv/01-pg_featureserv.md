This exercise will show you the steps to take to add pg_featureserv to your PostGIS implementation. 

First, take a look at the tab to the right called "pg_featureserv". You'll see that it's still waiting for an available connection on port 9000, the port that pg_featureserv serves data on. That's because we haven't added pg_featureserv to our PostGIS implementation yet. Let's do that now.

## Add pg_featureserv

To add pg_featureserv to your own PostGIS database, you need to either download the [source code](https://github.com/CrunchyData/pg_featureserv), or the binaries, or one of our supported containers. We've already pre-staged the container of pg_featureserv for this scenario.

The code block below allows you to click on it to have the code execute in the terminal on the right-hand side. Be sure to click on the ```Terminal``` tab before click on the box to make sure the code executes in the correct tab. You also have the option of copying and pasting the code, or typing it yourself in the ```Terminal``` tab.

```docker run -p 9000:9000 --env=DATABASE_URL=postgres://groot:password@172.18.0.2/nyc timmam/pg_featureserv:Katacoda```{{execute}}

You'll see that the connection info we provided in the intro (database name: `nyc`, username: `groot`, and password: `password`) is used in the statement above. 

You should see lines of output like this in the terminal:

```sh
time="2020-06-30T19:48:04Z" level=info msg="----  pg_featureserv - Version 1.1 ----------\n"
time="2020-06-30T19:48:04Z" level=info msg="Using config file: DEFAULT"
time="2020-06-30T19:48:04Z" level=info msg="Using database connection info from environment variable DATABASE_URL"
time="2020-06-30T19:48:04Z" level=info msg="pg-featureserv\n"
time="2020-06-30T19:48:04Z" level=info msg="Connected as groot to nyc @ 172.18.0.2"
time="2020-06-30T19:48:04Z" level=info msg="Serving at 0.0.0.0:9000\n"
time="2020-06-30T19:48:04Z" level=info msg="CORS Allowed Origins: *\n"
time="2020-06-30T19:48:04Z" level=info msg="172.17.0.2:34332 HEAD /\n"
time="2020-06-30T19:48:08Z" level=info msg="172.17.0.4:51916 GET /\n"
```

Once you do, open the pg_featureserv tab again, and you'll see that it has scucessfully connected to the default UI. We'll go over some additional information about how pg_featureserv works and the basic layout of the UI on the next pages.
