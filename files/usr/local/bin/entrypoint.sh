#!/usr/bin/env bash

mkdir /infra
wget https://raw.githubusercontent.com/okinta/alga-infra/master/infra/alga.yaml \
    /infra/alga.yaml

if [ "$1" = "setup" ]; then
    exec agrix provision /infra/alga.yaml

elif [ "$1" = "teardown" ]; then
    exec agrix destroy /infra/alga.yaml

else
    exec "$@"
fi
