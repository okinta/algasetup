#!/usr/bin/env bash

. common.sh

#
# Deletes a machine.
#
# Arguments:
#   The name of the machine to delete.
#
function delete {
    if [ -z "$1" ]; then
        echo "name argument must be provided" >&2
        exit 1
    fi

    local name=$1
    local id
    id=$(vultr-cli server list | grep "$name" | awk '{print $1}')
    vultr-cli server delete "$id"
}

#
# Deletes all the running machines related to Alga.
#
function run {
    echo "Deleting machines"
    delete stack-algatrader
    delete iqfeed
    delete stack-ibgateway
    echo "Done"
}

run
