```
docker pull dpage/pgadmin4
```{{execute}}
```
    docker run -p 80:80 \
        -e "PGADMIN_DEFAULT_EMAIL=user@domain.com" \
        -e "PGADMIN_DEFAULT_PASSWORD=SuperSecret" \
        -d dpage/pgadmin4
```{{execute}}	