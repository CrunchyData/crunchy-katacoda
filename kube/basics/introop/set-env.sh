#!/usr/bin/bash

cd /home/cent/postgres-operator/ansible

ansible-playbook -i inventory --tags=install main.yml

source ~/.bashrc