#!/usr/bin/bash

# Runs in the background

adduser training
echo "training" | passwd training --stdin
usermod -aG wheel training
echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

yum -y erase postgresql10-libs postgresql11* postgresql12*
yum -y remove pgdg-redhat-repo

rm -rf /var/lib/pgsql/*
