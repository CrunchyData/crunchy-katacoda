
## Configure Environment (Unlike optimise version is built)

```
yum install -y postgresql-server postgresql-contrib

postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql
```{{execute}}

