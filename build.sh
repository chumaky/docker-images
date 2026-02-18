#!/usr/bin/env bash

help() {
    echo "Usage: $0 <source> [<tag> [<base>]]"
    echo "  source  : source to build image for: postgres, mysql, etc."
    echo "  tag     : tag for the image. default: latest"
    echo "  base    : base postgres version to use. default: v18"
    exit 1
}

source=$1
if [ -z "$source" ]; then
    help
fi

tag=$2
if [ -z "$tag" ]; then
    tag="latest"
fi

base=$3
if [ -z "$base" ]; then
    base="v18"
fi

docker build --no-cache \
    -t chumaky/postgres_${source}_fdw:${tag} \
    -f ${base}/postgres_${source}.docker \
    ${base} > build.log 2>&1
