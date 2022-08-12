#!/bin/bash

rm -f ./sqlite.db
sqlite3 sqlite.db < ./sqlite_setup.sql