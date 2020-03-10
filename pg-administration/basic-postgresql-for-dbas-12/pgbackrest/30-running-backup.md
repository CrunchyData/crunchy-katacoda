Running backups is now as easy as running the backup command. Typically this is what is then added to a job scheduler, usually the `postgres` user's crontab.
```
sudo -Hiu postgres pgbackrest --stanza=main backup
```{{execute T1}}
If you read the output or the logs, you'll see that it detected no existing backups yet, so it runs a `full` backup. If you then run the same command again, you'll see that it detects an existing backup in the stanza, so only runs an incremental. You can just click the same command above to see that happen.

If you want to force a full backup, which you'll definitely want to do at some point in your schedule, you can pass the `--type` option to force any specific type.
```
sudo -Hiu postgres pgbackrest --stanza=main --type=full backup
```{{execute T1}}
Run the above two commands a few more times. If you cause more than 2 fulls to be created, the retention system is triggered to keep the backup counts to what was previously configured. And since incrementals rely on an underlying full backup to refer to, when that full is removed, all associated incrementals are also removed. To see the current inventory of backups in the repo, use the `info` command.
```
sudo -Hiu postgres pgbackrest info
```{{execute T1}}
