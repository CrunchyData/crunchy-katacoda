The first step to getting PostgreSQL running on a brand new system is to set the repositories that contain the latest package versions. For this demo we use CentOS7, but unfortunately the default repostory contains version 9.2 which has been EOL since Sept 2017 (https://www.postgresql.org/support/versioning).

Thankfully the PostgreSQL community provides an RPM repo that contains the latest version of not only postgres but many other popular third-party related tools as well (pgadmin, pgbouncer, pgbackrest, pg_partman, etc).

http://www.postgresql.org/download/linux/redhat

From here, select your desired version and the relevant RPM distro. In this case we want PostgreSQL 12 and CentOS7 64bit (x86_64). This will give you the relevant command to run to install the repo. 
```
sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
```{{execute T1}}

Confirm that this is ok and PostgreSQL is now ready to install!

Note there was a recent change regarding how the community repo is organized. Previously each major version had its own repo, but now changed to one universal repo per distro. If you're managing existing systems, it's important to make note of this change for future updates.

Next install the necessary package(s)
```
sudo yum install postgresql12-server postgresql12-contrib
```{{execute T1}}

If you just need the client programs (`psql`, `pg_dump`, `pg_restore`, etc), the `postgresql##` package can provide that without installing the whole server environment. The server package will pull this dependency.

The `postgresql##-contrib` package provides a suite of extra tools that are maintained by the core team. Even if you don't know whether you'll need them, it's recommended to install the package so they are readily available. Some popular examples are `pg_stat_statements`, `auto_explain`, and `dblink`. More can be found here: 

https://www.postgresql.org/docs/current/contrib.html


