# Final Notes 

We've now successfully used pg_basebackup to create a filesystem-based backup of a postgresql cluster. While this is a great basic option for doing so, it is very limited in many common features people typically want in their backups. Things like incremental or differential backups and a retention system. The pgBackRest tool discussed in the next Part can provide these features.

_Enjoy learning about PostgreSQL? [Sign up for our newsletter](https://www.crunchydata.com/newsletter/) and get the latest tips from us each month._