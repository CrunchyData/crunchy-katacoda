#!/usr/bin/bash

#runs in foreground

adduser training
echo "training" | passwd training --stdin

rm -rf /var/lib/pgsql/11/data/*
clear
