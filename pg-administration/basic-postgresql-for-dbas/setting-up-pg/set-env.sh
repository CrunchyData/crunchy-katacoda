#!/usr/bin/bash

#runs in foreground

CURRENT_USER=$(whoami)

until [ $CURRENT_USER == "training" ]; do
    sudo -iu training
    CURRENT_USER=$(whoami)
    echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for current user to change to training..."
    sleep 1;
done

