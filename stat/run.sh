#!/usr/bin/env bash

URL="https://hub.docker.com/v2/repositories/chumaky?page_size=25&ordering=last_updated"
JQ_TRANSFORM='.results[] | [.name, .pull_count, (.last_updated | sub("T"; " ") | sub("\\..*"; ""))] | @tsv'

printf "%-25s %-15s %-25s\n" "NAME" "PULL_COUNT" "LAST_UPDATED"
printf "%-25s %-15s %-25s\n" "----" "----------" "------------"
curl -sS "$URL" | jq -r "$JQ_TRANSFORM" | 
while IFS=$'\t' read -r name pull_count last_updated; do
    printf "%-25s %-15s %-25s\n" "$name" "$pull_count" "$last_updated"
done