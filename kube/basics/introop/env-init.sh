#!/usr/bin/bash

# nothing for now
launch.sh; kubectl wait pod -n pgo -l name=pgo-client --for=condition=ready