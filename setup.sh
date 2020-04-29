#!/usr/bin/env bash

. common.sh

#
# Provisions a machine.
#
# Arguments:
#   The name of the machine to provision.
#   (Optional) Whether or not to wait for the machine to provision. Set to
#   "wait" to wait. Defaults to "no-wait".
#   (Optional) The result variable to store the internal IP in.
#   (Optional) The result variable to store the ID in.
#
function provision {
    if [ -z "$1" ]; then
        echo "name argument must be provided" >&2
        exit 1
    fi

    local name=$1
    local wait=$2
    local __result_ip=$3
    local __result_id=$4

    local output
    local result
    if [ "$wait" = "wait" ]; then
        output=$(server "$name" --wait)
        result=$?
    else
        output=$(server "$name")
        result=$?
    fi

    echo "$output"
    if ! [ $result -eq 0 ]; then
        exit $result
    fi

    local __id
    __id=$(grep "Instance created - ID" <<< "$output" | awk -F " : " '{print $2}')
    if [ -z "$__id" ]; then
        echo "Could not find instance ID" >&2
        exit 1
    fi

    local __ip
    __ip=$(vultr-cli server info "$__id" | grep "Internal IP" | awk '{print $3}')
    if [ -z "$__ip" ]; then
        echo "Could not find internal IP" >&2
        exit 1
    fi

    if [[ "$__result_ip" ]]; then
        eval "$__result_ip=$__ip"
    fi

    if [[ "$__result_id" ]]; then
        eval "$__result_id=$__id"
    fi
}

#
# Provisions IQFeed. Blocks until provisioning is complete.
#
# Returns:
#   0 if successful, 1 otherwise.
#
function start_iqfeed {
    local TIMEOUT=900 # Wait 15 minutes for provision to complete

    echo "Provisioning IQFeed"
    ip=
    id=
    provision iqfeed no-wait ip id
    echo "Began provision for IQFeed ($id). Waiting for port to open."

    if wait-for-it -t $TIMEOUT "$ip:9400"; then
        echo "IQFeed is ready"
        return 0
    else
        echo "Timed out waiting for IQFeed to provision"
        vultr-cli server delete "$id"
        return 1
    fi
}

#
# Provisions IB Gateway. Blocks until provisioning is complete.
#
function start_ibgateway {
    echo "Provisioning IB Gateway"
    ip=
    provision stack-ibgateway wait ip
    echo "Provisioned IB Gateway. Waiting for port to open."
    wait-for-it "$ip:7000"
    echo "IB Gateway is ready"
}

#
# Provisions Algatrader. Blocks until provisioning is complete.
#
function start_algatrader {
    echo "Provisioning Algatrader"
    provision stack-algatrader wait
    echo "Provisioned algatrader"
}

#
# Provisions all the necessary machines for automatic trading.
#
function run {
    echo "Provisioning services"

    start_iqfeed
    local result=$?
    while [ $result -eq 1 ]; do
        sleep 5
        start_iqfeed
        result=$?
    done

    start_ibgateway
    start_algatrader
    echo "Done"
}

run
