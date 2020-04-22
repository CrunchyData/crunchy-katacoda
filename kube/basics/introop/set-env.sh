#!/usr/bin/bash
#Start Kube
: Please note this can take up to 3 minutes to full start - please be patient


launch.sh; until kubectl get pods -n pgo | grep -i running &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for The Operator to Start"
  sleep 2
done