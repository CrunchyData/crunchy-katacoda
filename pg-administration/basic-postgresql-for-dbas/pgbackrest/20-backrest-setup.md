A minimal `/etc/pgbackrest.conf` file is created by the package installation. We will be configuring a global section for settings that are common to all stanzas. And then some stanza specific settings. It's also possible to group settings into sections for specific commands as well. You can either run the command below or manually edit the config file yourself
```
sudo bash -c "cat > /etc/pgbackrest.conf << EOF
[global]
repo1-path=/var/lib/pgbackrest
log-level-console=info

[main]
pg1-path=/var/lib/pgsql/11/data
retention-full=2
EOF"
```{{execute T1}}

The `global` section has settings for the pgBackRest repository that will be common for any stanzas that are created. This is very useful when you have a dedicated backup system for many databases that should have some common settings such as the repository location and logging levels. The log level is also slightly increased from the default to give slightly more feedback when running commands manually.

Each stanza's settings are then placed under a `[stanza-name]` heading. In this case, it contains the path to our database's data directory and our retention policy. Here it is keeping 2 full backups. When the next ***successful*** backup exceeds this number, pgBackRest will automatically expire older backups.

With the configuration in place, the stanza can now be created in our repository. You'll typically be wanting to run the backups as the postgres system user, not root. The archive_command is run as the postgres system user, so it needs to be able to write to the repository. And then this allows the backups to be run as the postgres user as well, without requiring root.
```
sudo -Hiu postgres pgbackrest --stanza=main stanza-create
```{{execute T1}}
It's then good to run the check command to ensure pgBackRest is configured and working properly
```
sudo -Hiu postgres pgbackrest --stanza=main check
```{{execute T1}}
If either of these commands fail, you can check the pgBackRest logs located in `/var/log/pgbackrest` by default. If the issue is with the archive command, additional information as to why it's failing can also be found in the postgresql logs themselves (`/var/lib/pgsql/11/data/log`).
