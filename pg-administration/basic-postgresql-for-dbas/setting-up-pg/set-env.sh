#!/usr/bin/bash

#runs in foreground

adduser training
echo "training" | passwd training --stdin

yum -y erase postgresql10-libs postgresql11*
yum -y remove pgdg-redhat-repo

rm -rf /var/lib/pgsql/11/data/*
clear
