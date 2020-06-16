#!/usr/bin/env bash

PLATFORM_API_KEY=$(wget -q -O - http://vault.in.okinta.ge:7020/api/kv/vultr_api_key)
if [ -z "$PLATFORM_API_KEY" ]; then
    echo "Could not obtain Vultr API key from Vault" >&2
    exit 1
fi
export PLATFORM_API_KEY

mkdir /infra
wget -O /infra/alga.yaml \
    https://raw.githubusercontent.com/okinta/alga-infra/master/infra/alga.yaml

if [ "$1" = "setup" ]; then
    exec agrix provision /infra/alga.yaml

elif [ "$1" = "teardown" ]; then
    exec agrix destroy /infra/alga.yaml

else
    exec "$@"
fi
