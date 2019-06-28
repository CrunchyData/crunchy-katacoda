Creating Roles and Databases
----------------------------

TODO: CREATE A TRAINING USER ON SYSTEM WITH SUDO PRIVILEGES TO PROVIDE A MORE REALISTIC SCENARIO


As we discussed in the previous step, the default setup for the cluster provided by EL7 based systems is to allow peer based authentication. Back in our root user terminal, let's see what happens if we try and log into the database using just the `psql` command with no additional options
```
psql
```{{execute}}

