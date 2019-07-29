#!/usr/bin/bash

#runs in foreground

adduser training
echo "training" | passwd training --stdin

sudo systemctl enable postgresql-11
sudo systemctl start postgresql-11

sudo -u postgres psql -U postgres -c "CREATE ROLE root WITH LOGIN SUPERUSER"

sudo -u postgres psql -U postgres -c "CREATE DATABASE root"

clear
