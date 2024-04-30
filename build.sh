#!/usr/bin/env bash

docker build --no-cache \
    -t chumaky/postgres_duckdb_fdw \
    -f v16/postgres_duckdb.docker \
    v16 > build.log 2>&1
