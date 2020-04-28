#!/usr/bin/env bash

if [ "$1" = "setup" ]; then
    exec su - regan -c "/setup.sh"

else
    exec "$@"
fi
