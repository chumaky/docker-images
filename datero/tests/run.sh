#!/usr/bin/env bash

rm -f sqlite/job_roles.db
sqlite3 sqlite/job_roles.db < sqlite/job_roles.sql
chmod go+w sqlite
chmod go+w sqlite/job_roles.db

docker compose down
docker compose up -d