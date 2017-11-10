#!/bin/bash

# Initialize first run
if [[ -e /scripts/.firstrun ]]; then
    /scripts/first_run.sh
fi

# Start MongoDB
/usr/bin/mongod --dbpath /data --auth $@ 