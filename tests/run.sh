#!/usr/bin/env bash

help() {
    echo "Usage: $0 <source> [<command>]"
    echo "  source  : source to run tests for: postgres, mysql, etc."
    echo "  command : command to execute. default: up"
    exit 1
}

source=$1
if [ -z "$source" ]; then
    help
fi

action=$2
if [[ $action == "" ]]; then
    echo 'No action provided. Assuming "up"'
    action="up"
fi


if [[ $action == "up" ]]; then
    docker compose -f postgres_${source}_compose.yml $action --detach
elif [[ $action == "down" ]]; then
    docker compose -f postgres_${source}_compose.yml $action --volumes
else
    docker compose -f postgres_${source}_compose.yml $action
fi
