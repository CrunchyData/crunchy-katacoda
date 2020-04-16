#!/usr/bin/bash
#Start Kube
#launch.sh

#now install the operator
#cd /home/cent/postgres-operator/ansible

#ansible-playbook -i inventory --tags=install main.yml

#now source the env variables for the client
#source ~/.bashrc

launch.sh; kubectl wait pod -n pgo -l name=pgo-client --for=condition=ready