
## Configure Environment (Unlike optimise version is built)

Please wait for installation to finish.

This could take a few minutes


Execute the following to get the IP of the server to connect pgadmin to.

``` 
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' primary

```{{execute}}

Click on the following link to start pgadmin

Render port 5050: https://[[HOST_SUBDOMAIN]]-5050-[[KATACODA_HOST]].environments.katacoda.com/

username for pgadmin is admin@crunchydata.com, password is password

username and password for pgadmin is postgres/password




