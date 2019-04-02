
## Configure Environment (Unlike optimise version is built)

```
yum install -y postgresql11-server

/usr/pgsql-11/bin/postgresql-11-setup initdb
systemctl enable postgresql-11
systemctl start postgresql-11
```{{execute}}

