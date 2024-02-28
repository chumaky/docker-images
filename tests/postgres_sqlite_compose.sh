#!/usr/bin/env bash

script_dir="$(dirname "${BASH_SOURCE[0]}")"
cd $script_dir

tag=$1

if [ -z "$tag" ]
then
  tag=latest
fi

rm -rf ./test.db
sqlite3 test.db < ./sql/sqlite_setup.sql

docker run -d --rm --name postgres \
           -p 5432:5432 \
           -e POSTGRES_PASSWORD=postgres \
           -v ./test.db:/tmp/test.db:z \
           -v ./sql/postgres_sqlite_setup.sql:/docker-entrypoint-initdb.d/postgres_sqlite_setup.sql:z \
           docker.io/chumaky/postgres_sqlite_fdw:${tag}

docker exec postgres chmod o+w /tmp/test.db

docker ps
