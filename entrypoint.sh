#!/usr/bin/env bash

if [ "$1" = "setup" ]; then
    su-exec regan /app/setup.sh

else
    exec "$@"
fi
