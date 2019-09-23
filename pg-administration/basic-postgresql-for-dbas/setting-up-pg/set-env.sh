#!/usr/bin/bash

#runs in foreground

CURRENT_USER = $(whoami)

until [ $CURRENT_USER == "training" ]; do
    echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for current user to change to training..."
    sleep 1;
    sudo -iu training
    CURRENT_USER = $(whoami)

done

