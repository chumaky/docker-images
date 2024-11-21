#!/usr/bin/env bash

script_dir="$(dirname "${BASH_SOURCE[0]}")"
cd $script_dir

tag=$1

if [ -z "$tag" ]
then
  tag=latest
fi

rm -rf sqlite/test.db
sqlite3 sqlite/test.db < ./sql/sqlite_setup.sql

# sqlite db file and containing directory must be writable by others
# we must mount the sqlite db file containing directory
# otherwise, the postgres won't be able to write to the sqlite db file
chmod o+w sqlite
chmod o+w sqlite/test.db
ls -la sqlite

docker run -d --rm --name postgres \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    -v ./sqlite:/tmp/sqlite \
    -v ./sql/postgres_sqlite_setup.sql:/docker-entrypoint-initdb.d/postgres_sqlite_setup.sql \
    docker.io/chumaky/postgres_sqlite_fdw:${tag}

docker ps
