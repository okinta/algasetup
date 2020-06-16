#!/usr/bin/env bash

function on_sigint {
    echo "Exiting"
    exit 2
}
trap on_sigint SIGINT

# Grab Vultr's API key so we can provision servers
VULTR_API_KEY=$(wget -q -O - http://vault.in.okinta.ge:7020/api/kv/vultr_api_key)
export VULTR_API_KEY
if [ -z "$VULTR_API_KEY" ]; then
    echo "Could not obtain Vultr API key from Vault" >&2
    exit 1
fi

# Grab the SSH key so we can login to servers
id_rsa_private=$(wget -q -O - http://vault.in.okinta.ge:7020/api/kv/ssh_key_private)
if [ -z "$id_rsa_private" ]; then
    echo "Could not obtain private SSH key from Vault" >&2
    exit 1
fi

id_rsa_public=$(wget -q -O - http://vault.in.okinta.ge:7020/api/kv/ssh_key_public)
if [ -z "$id_rsa_public" ]; then
    echo "Could not obtain public SSH key from Vault" >&2
    exit 1
fi

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
echo "$id_rsa_private" > ~/.ssh/id_rsa
echo "$id_rsa_public" > ~/.ssh/id_rsa.pub
