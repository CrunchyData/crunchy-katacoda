#!/usr/bin/bash
#Start Kube
#launch.sh

#now install the operator
#cd /home/cent/postgres-operator/ansible

#ansible-playbook -i inventory --tags=install main.yml

#now source the env variables for the client
#source ~/.bashrc

#until PGPASSWORD="password" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
#  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
#  sleep 1
#done

launch.sh; until kubectl get pods -n pgo | grep -i running &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting The Operator to Start"
  sleep 1
done