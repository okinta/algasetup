#!/usr/bin/env bash

if [ "$1" = "setup" ]; then
    su-exec regan /app/setup.sh

elif [ "$1" = "teardown" ]; then
    su-exec regan /app/teardown.sh

else
    exec "$@"
fi
