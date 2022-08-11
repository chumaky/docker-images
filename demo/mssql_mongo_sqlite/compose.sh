#!/bin/bash

rm -f ./test.db
sqlite3 test.db < ./sqlite_setup.sql

podman-compose -f compose.yml up -d